extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_retry_pressed() -> void:
	#print('Rerouting...')
	get_tree().change_scene_to_file("res://Scenes/main_game_scene.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
