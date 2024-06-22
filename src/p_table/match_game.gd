extends Control

@onready var spawningPlace: CenterContainer = %NewElementPlace
@onready var pTable = $PTable
@onready var allElements = $AllElements
@onready var storagePoints = %StoragePoints
@onready var deductionLabel = %Deduction
@onready var timeLabel = %TimePassed
@onready var gameBlocker = $Blocker
@onready var hintBox = $GamePanel/Columns/HintBox
@onready var gameStarter: Timer = $GameStarter
@onready var tipContainer = %Tips
var activeStorage: CenterContainer = null
var deduction: int = 0
var hintsRevealed: int = 0
var moved: int = 0
var elementsAdded: int = 0
var hintPenalties: Dictionary = {
	"Atomic mass": -40,
	"Compound 1": -15,
	"Compound 2": -15,
	"Compound 3": -10,
	"Trivia": -5
}
var hintToolTips: Dictionary = {
	"Compound 1": "Common compound",
	"Compound 2": "Common compound",
	"Compound 3": "Strange compound",
}
var selectedElement: Container = null
var startTime: float
var tiplist: Array

func _ready():
	pTable.initialize(allElements)
	for child in tipContainer.get_children():
		tiplist.append(child)
	tiplist[0].show()

func startGame():
	startTime = Time.get_unix_time_from_system()
	addElement()
	for storage in storagePoints.get_children():
		storage.activate.connect(storageActivated.bind(storage))
		storage.deactivate.connect(storageDeactivated.bind(storage))
	hintBox.setPenaltyNumbers(hintPenalties, hintToolTips)

func addElement():
	var elementNode: Control = allElements.giveRandomElement()
	if elementNode == null:
		return
	elementsAdded += 1
	selectedElement = elementNode
	hintBox.elementSelected(elementNode)
	elementNode.dropped.connect(elementDropped.bind(elementNode))
	spawningPlace.add_child(elementNode)

func elementDropped(elementNode):
	var toAdd: bool = (elementNode in spawningPlace.get_children())
	#Handle the element being selected
	selectedElement = elementNode
	hintBox.elementSelected(elementNode)
	#Check if the element is moved from the temporary place or spawn point
	if not elementNode in (spawningPlace.get_children()):
		var inStorage: bool = false
		for child in storagePoints.get_children():
			if child.getElement() == elementNode:
				inStorage = true
				break
		if not inStorage:
			deduction -= 50
			moved += 1
	#Check whether the element is moving to storage or to the periodic table
	if activeStorage == null:
		var result: bool = pTable.elementDropped(elementNode)
		if not result:
			return
	else:
		activeStorage.addElement(elementNode)
	if toAdd:
		addElement()
	#Check whether the temporary storage is empty & we're out of elements
	#to see if the game is over or not.
	var allEmpty: bool = true
	if len(spawningPlace.get_children()) == 0:
		for storage in storagePoints.get_children():
			if storage.getElement() != null:
				allEmpty = false
				break
		if allEmpty:
			finishGame()
	#update deductions
	deductionLabel.text = str(deduction)

func storageActivated(storageNode):
	activeStorage = storageNode

func storageDeactivated(storageNode):
	if activeStorage == storageNode:
		activeStorage = null
	else:
		assert(false, "Something went wrong")

func _on_hint_box_hint_opened(hintName):
	var hint: String = selectedElement.getHint(hintName)
	if hint != "":
		deduction += hintPenalties[hintName]
		deductionLabel.text = str(deduction)
		if hintPenalties[hintName] != 0:
			hintsRevealed += 1
	hintBox.revealHint(hintName, hint)

func finishGame():
	var matchedElements: int = pTable.checkElements()
	var timePassed: float = Time.get_unix_time_from_system() - startTime + 0.3
	var timeBonus: int = round(
		10000 / sqrt(timePassed) * (float(matchedElements) / float(elementsAdded))
	)
	var score = matchedElements * 100 + deduction + timeBonus
	gameBlocker.show()
	%TimeKeeper.stop()
	%Score.text = str(score)
	%Matches.text = str(matchedElements)# + " (" + str(matchedElements * 100) + ")"
	%TimeBonus.text = str(timeBonus)
	%Moves.text = str(moved)
	%Hints.text = str(hintsRevealed)

func _on_time_keeper_timeout():
	var timePassed: float = Time.get_unix_time_from_system() - startTime + 0.3
	var timeString: String
	if timePassed < 0:
		timeString = str(int(timePassed-0.5))
	else:
		timeString = (
			"%d" % (int(timePassed) / 60) + ":" +
			"%02d" % (int(timePassed) % 60)
		)
	timeLabel.text = timeString


func _on_close_button_pressed():
	for child in tiplist:
		child.hide()
	tipContainer.hide()
	gameStarter.start()
	%TimeKeeper.start()
	startTime = Time.get_unix_time_from_system() + gameStarter.time_left
	timeLabel.text = str(-int(gameStarter.time_left))

func _on_step_button_pressed():
	for index in range(len(tiplist)):
		if tiplist[index].visible:
			tiplist[index].hide()
			tiplist[index+1].show()
			break
