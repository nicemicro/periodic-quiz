extends CenterContainer

@export var symbol: String

@onready var symbolLabel: Label = $Panel/Label
@onready var mouseGhost: Sprite2D = $MouseMover

var clickPos: Vector2 = Vector2(0, 0)
var ghosting: bool = false

func _ready():
	symbolLabel.text = symbol

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
	if ghosting and event is InputEventMouseMotion:
		mouseGhost.position = event.global_position - clickPos

