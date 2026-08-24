extends StaticBody3D

@export var minimum_speed := 8.0

func check_surfboard(board: RigidBody3D) -> void:

	var speed := Vector3(
		board.linear_velocity.x,
		0.0,
		board.linear_velocity.z
	).length()

	if speed < minimum_speed:
		fail_ramp(board)
	else:
		clear_ramp(board)

func clear_ramp(board):
	print("Success")
	
func fail_ramp(board):
	print("fail")
	pass
func _on_ramp_trigger_body_entered(body: Node3D) -> void:
	if not body is RigidBody3D:
		return

	var board := body as RigidBody3D

	var horizontal_velocity := Vector3(
		board.linear_velocity.x,
		0.0,
		board.linear_velocity.z
	)

	var speed := horizontal_velocity.length()

	if speed >= minimum_speed:
		print("CLEAR RAMP! Speed: ", speed)
	else:
		print("TOO SLOW! Speed: ", speed)
	print(board)


func _on_ramp_trigger_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
