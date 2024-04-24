extends CenterContainer

@export var symbol: String

@onready var symbolLabel: Label

func _ready():
	symbolLabel.text = symbol
