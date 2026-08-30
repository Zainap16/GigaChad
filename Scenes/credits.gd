extends VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
func _on_skip_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
