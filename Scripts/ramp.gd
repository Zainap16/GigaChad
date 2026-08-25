extends StaticBody3D
##minimum_speed to activate the launch_force
@export var minimum_speed := 8.0
##Force applied when minimum_speed is met
@export var launch_force := 8.0
##Max speed to cause falling off
@export var maximum_safe_speed := 15.0

func _on_ramp_trigger_body_entered(body: Node3D) -> void:

	if not body is RigidBody3D:
		return

	check_surfboard(body as RigidBody3D)


func check_surfboard(board: RigidBody3D) -> void:

	var horizontal_velocity := Vector3(
		board.linear_velocity.x,
		0.0,
		board.linear_velocity.z
	)

	var speed := horizontal_velocity.length()

	if speed < minimum_speed:
		fail_ramp(board)

	elif speed > maximum_safe_speed:
		overspeed_ramp(board)

	else:
		clear_ramp(board)

##Go over ramp
func clear_ramp(board: RigidBody3D) -> void:

	print("Success")
	launch_board(board)

##Speed not met
func fail_ramp(board: RigidBody3D) -> void:
#i thik when it fails i should change the mask/layer to go through the ramp
	if board.name == "Surfboard":
		board.set_collision_mask_value(3, false)

	print("TOO SLOW")

##When speed is reached to high, sink
func overspeed_ramp(board: RigidBody3D) -> void:

	if board.name == "Surfboard":

		board.start_sinking()

		print("TOO FAST - SINK!")
##Launch board when minimum_speed is met
func launch_board(board: RigidBody3D) -> void:

	var ramp_forward := -global_transform.basis.z

	var launch_direction := (
		ramp_forward + Vector3.UP
	).normalized()

	board.apply_central_impulse(
		launch_direction * launch_force
	)


func _on_ramp_trigger_body_exited(body: Node3D) -> void:
	if body.name == "Surfboard":
		body.set_collision_mask_value(3, true) 
		print(get_collision_mask_value(3))
