extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	#print('Game start')
	get_tree().change_scene_to_file("res://Scenes/main_game_scene.tscn")


func _on_options_pressed() -> void:
	print('Settings Loading...')


func _on_exit_pressed() -> void:
	#print('No!')
	get_tree().quit()
