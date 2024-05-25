extends MarginContainer

@onready var infoText = $Info
@onready var button = $Button
var penalty: int = 0

signal revealPressed

func _ready():
	button.tooltip_text = "Penalty: " + str(penalty)

func setPenalty(newPenalty: int):
	penalty = newPenalty
	if button != null:
		button.tooltip_text = "Penalty: " + str(penalty)

func revealInfo(info: String):
	button.hide()
	if info == "":
		info = "[i]N/A[/i]"
	infoText.text = info
	infoText.show()

func hideInfo():
	button.show()
	infoText.text = ""
	infoText.hide()

func _on_button_pressed():
	revealPressed.emit()
