extends Control

@onready var spawningPlace: CenterContainer = $GamePanel/Columns/Spawn/ElementPlace
@onready var pTable = $PTable
@onready var storagePoints = $GamePanel/Columns/Storage/StoragePoints
var activeStorage: CenterContainer = null

func _ready():
	addElement("He")
	for storage in storagePoints.get_children():
		storage.activate.connect(storageActivated.bind(storage))
		storage.deactivate.connect(storageDeactivated.bind(storage))

func addElement(symbol: String):
	var elementScene: PackedScene = load("res://p_table/element.tscn")
	var elementNode = elementScene.instantiate()
	elementNode.symbol = symbol
	elementNode.dropped.connect(elementDropped.bind(elementNode))
	spawningPlace.add_child(elementNode)

func elementDropped(elementNode):
	if activeStorage == null:
		pTable.elementDropped(elementNode)
		return
	activeStorage.addElement(elementNode)

func storageActivated(storageNode):
	activeStorage = storageNode

func storageDeactivated(storageNode):
	if activeStorage == storageNode:
		activeStorage = null
	else:
		assert(false, "Something went wrong")
