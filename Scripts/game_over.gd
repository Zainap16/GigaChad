extends Node2D

@onready var fade: ColorRect = $UI/Fade

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Start completely transparent
	fade.modulate.a = 0.0

func _on_retry_pressed() -> void:
	#print('Rerouting...')
	#get_tree().change_scene_to_file("res://Scenes/main_game_scene.tscn")
	fade_to_scene("res://Scenes/main_game_scene.tscn")
	
	


func _on_menu_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	fade_to_scene("res://Scenes/main_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
	
func fade_to_scene(scene_path: String) -> void:

	var tween := create_tween()

	tween.tween_property(
		fade,
		"modulate:a",
		1.0,
		1.0
	)

	await tween.finished

	get_tree().change_scene_to_file(scene_path)
