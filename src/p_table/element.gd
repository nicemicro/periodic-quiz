extends CenterContainer

@export var _symbol: String = "He"
@export var _relativeAtomicMass: float = 4.00

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

func getOpenedInfo() -> Dictionary:
	var retDict: Dictionary = revealedHints.duplicate()
	retDict["symbol"] = _symbol
	return retDict

func getHint(hintName) -> String:
	var response: String = ""
	match hintName:
		"Atomic mass":
			response = "%.2f" % _relativeAtomicMass
			revealedHints[hintName] = response
		_:
			revealedHints[hintName] = ""
	return response

func setLoc(elementLoc):
	assert(_elementLoc == -1, "Shouldn't set element location again once set")
	_elementLoc = elementLoc

func getLoc() -> int:
	return _elementLoc

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

