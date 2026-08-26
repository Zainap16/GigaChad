extends Node3D
##If the camera is still moving too much, lower the camera's follow/rotation speed:
@export var follow_speed := 8.0
@export var rotation_speed := 5.0

@export var camera_height := 4.0
@export var camera_distance := 7.0

#func _ready() -> void:


func _process(delta: float) -> void:

	if WaveManager.player == null:
		return

	# Follow player's position
	var target_position := WaveManager.player.global_position

	target_position.y += camera_height

	global_position = global_position.lerp(
		target_position,
		follow_speed * delta
	)

	# Follow player's horizontal direction
	var target_y := WaveManager.player.global_rotation.y

	rotation.y = lerp_angle(
		rotation.y,
		target_y,
		rotation_speed * delta
	)
