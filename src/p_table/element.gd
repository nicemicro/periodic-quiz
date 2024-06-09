@tool
extends CenterContainer
class_name ElementNode

@export var _symbol: String = "He":
	set(newSymbol):
		_symbol = newSymbol
		if symbolLabel == null:
			return
		symbolLabel.text = _symbol
		_typicalCompound1 = _symbol
		_typicalCompound2 = ""
		_weirdCompound = ""
		_trivia = ""
@export var _relativeAtomicMass: float = 4.00
@export var _typicalCompound1: String = "He"
@export var _typicalCompound2: String = ""
@export var _weirdCompound: String = "He[sub]2[/sub][sup x_off=-6]+[/sup]"
@export var _trivia: String = "Smallest atom"
@export var _difficulty: int = 1

var _elementLoc: int = -1

@onready var colorBg: ColorRect = $ColorPanel
@onready var symbolLabel: Label = $ColorPanel/Label
@onready var mouseGhost: Sprite2D = $MouseMover
@onready var ghostLabel: Label = $MouseMover/Label2

var clickPos: Vector2 = Vector2(0, 0)
var ghosting: bool = false
var revealedHints: Dictionary = {}

signal dropped

func _ready():
	symbolLabel.text = _symbol
	ghostLabel.text = _symbol
	tooltip_text = ""

func getOpenedInfo() -> Dictionary:
	var retDict: Dictionary = revealedHints.duplicate()
	retDict["symbol"] = _symbol
	return retDict

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)

func getHint(hintName) -> String:
	var response: String = ""
	match hintName:
		"Atomic mass":
			response = "%.2f" % _relativeAtomicMass
			revealedHints[hintName] = response
		"Typical compound 1":
			response = _typicalCompound1
		"Typical compound 2":
			response = _typicalCompound2
		"Strange compound":
			response = _weirdCompound
		"Trivia":
			response = _trivia
		_:
			revealedHints[hintName] = ""
	revealedHints[hintName] = response
	tooltip_text = ""
	for hint in revealedHints:
		if revealedHints[hint] != "":
			tooltip_text = (
				tooltip_text + hint + ": " +
				strip_bbcode(revealedHints[hint]) + "\n"
			)
	return response

func setLoc(elementLoc):
	assert(_elementLoc == -1, "Shouldn't set element location again once set")
	_elementLoc = elementLoc

func getLoc() -> int:
	return _elementLoc

func getDifficulty() -> int:
	return _difficulty

func setIncorrect():
	colorBg.color = Color(1.0, 0.3, 0.3)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			mouseGhost.visible = true
			clickPos = event.global_position
			ghosting = true
		if ghosting and not event.pressed:
			ghosting = false
			mouseGhost.visible = false
			mouseGhost.position = Vector2(0, 0)
			dropped.emit()
	if ghosting and event is InputEventMouseMotion:
		mouseGhost.position = event.global_position - clickPos

