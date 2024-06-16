extends Node2D

@onready var player = $"../Player"
var save_path = "user://savegame.save"

func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://level.tscn")



func _on_load_button_pressed():
	load_game()

func load_game():
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	Global.player_gold = file.get_var(Global.player_gold)
	Global.player_kills = file.get_var(Global.player_kills)
	Global.player_health = file.get_var(Global.player_health)
	player.position.x = file.get_var(player.position.x)
	player.position.y = file.get_var(player.position.y)
	Global.day_count = file.get_var(Global.day_count)
