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
	if len(elementList) == 0:
		return null
	var currentDiff: int = 1
	var baseDiff: int = -1
	var choseFrom: Array = []
	var minLength: int = 5
	while len(choseFrom) < minLength and len(choseFrom) < len(elementList):
		for elementNum in elementList:
			if elementList[elementNum].getDifficulty() == currentDiff:
				if baseDiff == -1:
					baseDiff = currentDiff
				choseFrom.append(elementNum)
			if currentDiff > baseDiff and len(choseFrom) >= minLength:
				break
		currentDiff += 1
	#var num: int = 1
	#for index in choseFrom:
		#print(num, ":", index, ": ", elementList[index].getOpenedInfo()["symbol"])
		#num += 1
	#print()
	var chosenNum: int = randi() % len(choseFrom)
	var chosenInd: int = choseFrom[chosenNum]
	var chosenEl: Control = elementList[chosenInd]
	elementList.erase(chosenInd)
	remove_child(chosenEl)
	return chosenEl
