extends CenterContainer

@export var _symbol: String = "He"

var _elementLoc: int = -1

@onready var symbolLabel: Label = $Panel/Label
@onready var mouseGhost: Sprite2D = $MouseMover
@onready var ghostLabel: Label = $MouseMover/Label2

var clickPos: Vector2 = Vector2(0, 0)
var ghosting: bool = false

signal dropped

func _ready():
	symbolLabel.text = _symbol
	ghostLabel.text = _symbol

func setLoc(elementLoc):
	assert(_elementLoc == -1, "Shouldn't set element location again once set")
	_elementLoc = elementLoc

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
			emit_signal("dropped")
	if ghosting and event is InputEventMouseMotion:
		mouseGhost.position = event.global_position - clickPos

