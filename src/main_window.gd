extends Control

@onready var mainMenu: Control = $MainMenu
@onready var gamePlace: Control = $GamePlace

func _on_match_game_pressed():
	var gameNode: Control = load("res://p_table/match_game.tscn").instantiate()
	mainMenu.hide()
	gamePlace.add_child(gameNode)
	
