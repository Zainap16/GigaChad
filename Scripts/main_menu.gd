extends Node2D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_start_pressed() -> void:
	#print('Game start')
	get_tree().change_scene_to_file("res://Scenes/main_game_scene.tscn")


func _on_options_pressed() -> void:
	print('Settings Loading...')


func _on_exit_pressed() -> void:
	#print('No!')
	get_tree().quit()
