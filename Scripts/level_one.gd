extends Node3D

@export var shark_scene: PackedScene

@export_category("Spawn Settings")
@export var spawn_cooldown := 10.0

var spawn_timer := 0.0
var shark_active := false


func _ready() -> void:

	var spawn_points := get_tree().get_nodes_in_group("shark_spawn")

	print("Shark spawn points found: ", spawn_points.size())


func _process(delta: float) -> void:

	if shark_active:
		return

	spawn_timer += delta

	if spawn_timer >= spawn_cooldown:
		spawn_shark()
		spawn_timer = 0.0

func spawn_shark() -> void:

	var spawn_points := get_tree().get_nodes_in_group("shark_spawn")

	if spawn_points.is_empty():
		push_warning("No shark spawn points found!")
		return

	var spawn_point = spawn_points.pick_random()

	var shark := shark_scene.instantiate()

	get_tree().current_scene.add_child(shark)

	shark.global_position = spawn_point.global_position

	shark_active = true
