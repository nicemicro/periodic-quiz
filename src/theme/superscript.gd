extends RichTextEffect
class_name Superscript

var bbcode = "sup"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var horiz: int = int(char_fx.env.get("x_off", 0))
	#char_fx.offset.y = 8
	char_fx.transform = Transform2D(
		char_fx.transform.get_rotation(),
		Vector2(0.8, 0.8),
		0.,
		char_fx.transform.get_origin() + Vector2(horiz, -6),
	)
	return true
