extends Control

@onready var spawningPlace: CenterContainer = %NewElementPlace
@onready var pTable = $PTable
@onready var allElements = $AllElements
@onready var storagePoints = %StoragePoints
@onready var deductionLabel = %Deduction
@onready var gameBlocker = $Blocker
@onready var scoreLabel = %Score
@onready var matchesLabel = %Matches
@onready var hintBox = $GamePanel/Columns/HintBox
var activeStorage: CenterContainer = null
var score: int = 0
var hintPenalties: Dictionary = {
	"Atomic mass": -40,
	"Typical compound": -15,
	"Strange compound": -10
}
var selectedElement: Container = null

func _ready():
	addElement()
	for storage in storagePoints.get_children():
		storage.activate.connect(storageActivated.bind(storage))
		storage.deactivate.connect(storageDeactivated.bind(storage))
	hintBox.setPenaltyNumbers(hintPenalties)

func addElement():
	var elementNode: Control = allElements.giveRandomElement()
	if elementNode == null:
		return
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
			score -= 50
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
	deductionLabel.text = str(score)

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
		score += hintPenalties[hintName]
		deductionLabel.text = str(score)
	hintBox.revealHint(hintName, hint)

func finishGame():
	var matchedElements: int = pTable.checkElements()
	score += matchedElements * 100
	gameBlocker.show()
	scoreLabel.text = str(score)
	matchesLabel.text = str(matchedElements)
