extends GridContainer

const EL_PLACE_PATH = "uid://d457mukcsa8n"
const EMPTY_PATH = "uid://ckdkb4ss1xtta"
const ELEMENT_PATH = "uid://c4o2xmg1nph1u"

const PTABLE = [
	[1, 16, 1],
	[2, 10, 6],
	[2, 10, 6],
	[18],
	[18],
	[2, 1, 15],
	[2, 1, 15],
	[0, 18],
	[0, 3, 15],
	[0, 3, 15]
]

var elementPlaces: Array = []
var activeStorage: CenterContainer = null

func _ready():
	var el_now: bool = true
	var col_num: int = 0
	var instance: CenterContainer
	for line in PTABLE:
		col_num = 0
		el_now = true
		for cols in line:
			for num in range(cols):
				if el_now:
					instance = load(EL_PLACE_PATH).instantiate()
					elementPlaces.append(instance)
					instance.activate.connect(storageActivated.bind(instance))
					instance.deactivate.connect(storageDeactivated.bind(instance))
				else:
					instance = load(EMPTY_PATH).instantiate()
				add_child(instance)
				col_num += 1
			el_now = not el_now

func checkElements() -> int:
	var correct: int = 0
	var index: int = -1
	for elementPlace in elementPlaces:
		if elementPlace == null:
			continue
		index += 1
		if elementPlace.getElement() == null:
			continue
		if elementPlace.getElement().getLoc() == index:
			correct += 1
	return correct

func  elementDropped(elementNode) -> bool:
	if activeStorage == null:
		return false
	activeStorage.addElement(elementNode)
	return true

func storageActivated(storageNode):
	activeStorage = storageNode

func storageDeactivated(storageNode):
	if activeStorage == storageNode:
		activeStorage = null
	else:
		assert(false, "Something went wrong")
