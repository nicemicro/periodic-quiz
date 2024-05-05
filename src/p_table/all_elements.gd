extends GridContainer

var elementList: Dictionary = {}

func _ready():
	randomize()
	var counter: int = 0
	for childNode in get_children():
		elementList[counter] = childNode
		childNode.setLoc(counter)
		counter += 1

func giveRandomElement() -> Control:
	var chosenNum: int = randi() % len(elementList)
	var chosenInd: int = elementList.keys()[chosenNum]
	var chosenEl: Control = elementList[chosenInd]
	elementList.erase(chosenInd)
	remove_child(chosenEl)
	return chosenEl
