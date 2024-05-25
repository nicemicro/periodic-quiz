extends VBoxContainer

@onready var elementSymbol = $InfoGrid/Symbol
@onready var infoGrid = $InfoGrid
var hintList: Dictionary = {}
signal hintOpened(hintName)

func setPenaltyNumbers(newPenaltyNumbers: Dictionary):
	var revealerScene = load("res://p_table/hint_revealer.tscn")
	var revealerNode: Control
	var labelNode: Label
	for hintName in newPenaltyNumbers:
		labelNode = Label.new()
		labelNode.text = hintName + ":"
		labelNode.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		labelNode.add_theme_font_size_override("font_size", 15)
		infoGrid.add_child(labelNode)
		revealerNode = revealerScene.instantiate()
		revealerNode.setPenalty(newPenaltyNumbers[hintName])
		revealerNode.revealPressed.connect(revealHintPressed.bind(hintName))
		hintList[hintName] = revealerNode
		infoGrid.add_child(revealerNode)

func revealHintPressed(hintName):
	hintOpened.emit(hintName)

func revealHint(hintName, value):
	hintList[hintName].revealInfo(value)

func elementSelected(elementNode: Control):
	var hints: Dictionary = elementNode.getOpenedInfo()
	elementSymbol.text = hints["symbol"]
	for hintType in hintList.keys():
		if hintType in hints.keys():
			hintList[hintType].revealInfo(hints[hintType])
		else:
			hintList[hintType].hideInfo()
