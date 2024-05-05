extends Control

@onready var spawningPlace: CenterContainer = $GamePanel/Columns/Spawn/ElementPlace
@onready var pTable = $PTable
@onready var allElements = $AllElements
@onready var storagePoints = $GamePanel/Columns/Storage/StoragePoints
var activeStorage: CenterContainer = null

func _ready():
	addElement()
	for storage in storagePoints.get_children():
		storage.activate.connect(storageActivated.bind(storage))
		storage.deactivate.connect(storageDeactivated.bind(storage))

func addElement():
	var elementNode: Control = allElements.giveRandomElement()
	elementNode.dropped.connect(elementDropped.bind(elementNode))
	spawningPlace.add_child(elementNode)

func elementDropped(elementNode):
	if activeStorage == null:
		var result: bool = pTable.elementDropped(elementNode)
		if not result:
			return
	else:
		activeStorage.addElement(elementNode)
	addElement()

func storageActivated(storageNode):
	activeStorage = storageNode

func storageDeactivated(storageNode):
	if activeStorage == storageNode:
		activeStorage = null
	else:
		assert(false, "Something went wrong")
