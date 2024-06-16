extends GridContainer

const EL_PLACE_PATH = "uid://d457mukcsa8n"
const EMPTY_PATH = "uid://ckdkb4ss1xtta"
const ELEMENT_PATH = "uid://c4o2xmg1nph1u"

var elementPlaces: Array = []
var activeStorage: CenterContainer = null

func initialize(allElements: PTableFull):
	var col_num: int = 0
	var instance: CenterContainer
	for child in allElements.get_children():
		col_num = 0
		if child is ElementNode:
			instance = load(EL_PLACE_PATH).instantiate()
			elementPlaces.append(instance)
			instance.activate.connect(storageActivated.bind(instance))
			instance.deactivate.connect(storageDeactivated.bind(instance))
		else:
			instance = load(EMPTY_PATH).instantiate()
		add_child(instance)

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
		else:
			elementPlace.getElement().setIncorrect()
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
