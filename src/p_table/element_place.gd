extends CenterContainer

@onready var elementParent: CenterContainer = $ElementParent
@onready var activeColor: TextureRect = $PanelActive

var active: bool = false
signal activate
signal deactivate

func addElement(newElement: CenterContainer):
	if elementParent.get_child_count() > 0:
		assert(false, "This shouldn't be called like this")
		return
	newElement.reparent(elementParent)
	deactivation()

func getElement() -> CenterContainer:
	return elementParent.get_child(0)

func _on_mouse_entered():
	if active or elementParent.get_child_count() > 0:
		return
	active = true
	activeColor.visible = true
	emit_signal("activate")

func _on_mouse_exited():
	if not active or elementParent.get_child_count() > 0:
		return
	deactivation()

func deactivation():
	active = false
	activeColor.visible = false
	emit_signal("deactivate")
