extends Node3D

@export var shark_scene: PackedScene

@onready var spawn_marker: Marker3D = $Marker3D

var shark_spawned := false


func _on_body_entered(body: Node3D) -> void:
	if shark_spawned:
		return

	if not body.name == "Surfboard":
		return

	spawn_shark()


func spawn_shark() -> void:

	shark_spawned = true

	var shark := shark_scene.instantiate()

	get_tree().current_scene.add_child(shark)

	shark.global_position = spawn_marker.global_position

	print("SHARK SPAWNED!")
