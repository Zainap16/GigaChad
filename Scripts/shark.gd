extends CharacterBody3D

@export_category("Shark")
@export var move_speed := 12.0
@export var acceleration := 5.0
@export var rotation_speed := 3.0

@export_category("Target")
@export var player: CharacterBody3D


func _physics_process(delta: float) -> void:

	if player == null:
		return

	chase_player(delta)


func chase_player(delta: float) -> void:

	var direction := (
		player.global_position - global_position
	).normalized()

	# Move toward player
	velocity = velocity.lerp(
		direction * move_speed,
		acceleration * delta
	)

	move_and_slide()

	# Face player
	look_at(
		global_position + direction,
		Vector3.UP
	)
