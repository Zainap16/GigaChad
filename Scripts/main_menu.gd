extends Node2D

@onready var fade: ColorRect = $UI/Fade
@onready var instructions: ColorRect = $UI/Control/Instructions

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Start completely transparent
	fade.modulate.a = 0.0
	
	instructions.visible = false
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_start_pressed() -> void:
	#print('Game start')
	fade_to_scene("res://Scenes/main_game_scene.tscn")


func _on_options_pressed() -> void:
	print('Settings credits...')
	instructions.visible = true


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


func _on_exit_controls_pressed() -> void:
	instructions.visible = false
