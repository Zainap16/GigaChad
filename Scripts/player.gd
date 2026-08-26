extends Node3D

@onready var camera_mount: Node3D = $camera_mount
@onready var visuals: Node3D = $visuals

@export var surfboard: RigidBody3D
@export var player_anchor: Marker3D

var is_on_surfboard := false

@export var can_move := false


@export_category("Camera")
@export var sens_horizontal: float = 0.2
@export var sens_vertical: float = 0.2


@export_category("Surfing Lean")
@export var max_forward_lean := 15.0
@export var max_backward_lean := 10.0
@export var max_side_lean := 20.0
@export var lean_speed := 8.0

var target_lean := Vector3.ZERO


@export_category("Shark Escape")
@export var escape_time := 4.0

var escape_timer := 0.0
var escaping_shark := false

##makes camera move slowly the lower the number is
@export var rotation_smoothing := 5.0
func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	mount_surfboard()


func _input(event):

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if event is InputEventMouseMotion:

		camera_mount.rotate_x(
			deg_to_rad(-event.relative.y * sens_vertical)
		)

		camera_mount.rotation.x = clamp(
			camera_mount.rotation.x,
			deg_to_rad(-90),
			deg_to_rad(45)
		)

		rotate_y(
			deg_to_rad(-event.relative.x * sens_horizontal)
		)


func _process(delta: float) -> void:

	if not is_on_surfboard:
		return

	if can_move:
		update_lean(delta)
	#update_camera(delta)
	#update_shark_escape(delta)


## --------------------------------
## SURFING LEAN
## --------------------------------

func update_lean(delta: float) -> void:

	var input := get_surf_input()

	# Forward / backward lean
	if input.y > 0.0:
		target_lean.x = deg_to_rad(-max_forward_lean)

	elif input.y < 0.0:
		target_lean.x = deg_to_rad(max_backward_lean)

	else:
		target_lean.x = 0.0


	# Left / right lean
	target_lean.z = deg_to_rad(
		-input.x * max_side_lean
	)


	# Smoothly move toward the target lean
	visuals.rotation.x = lerp_angle(
		visuals.rotation.x,
		target_lean.x,
		lean_speed * delta
	)

	visuals.rotation.z = lerp_angle(
		visuals.rotation.z,
		target_lean.z,
		lean_speed * delta
	)


## --------------------------------
## INPUT
## --------------------------------

func get_surf_input() -> Vector2:

	return Input.get_vector(
		"left",
		"right",
		"backward",
		"forward"
	)


## --------------------------------
## MOUNT SURFBOARD
## --------------------------------

func mount_surfboard() -> void:

	is_on_surfboard = true

	#global_transform = player_anchor.global_transform


## --------------------------------
## CAMERA
## --------------------------------

func update_camera_direction() -> void:

	var board_basis := surfboard.global_transform.basis

	var board_yaw := atan2(
		-board_basis.z.x,
		-board_basis.z.z
	)

	camera_mount.global_rotation.y = board_yaw


## --------------------------------
## SHARK ESCAPE
## --------------------------------

func update_shark_escape(delta: float) -> void:

	if not escaping_shark:
		return

	var input := Input.get_axis(
		"backward",
		"forward"
	)

	if input > 0.0:

		escape_timer += delta

	else:

		escape_timer = 0.0

	if escape_timer >= escape_time:

		escape_shark()


func escape_shark() -> void:

	print("ESCAPED SHARK!")

	escape_timer = 0.0
	escaping_shark = false
	
	

	# Tell shark to despawn


func update_camera(delta: float) -> void:

	var target_rotation := Vector3(
		0.0,
		rotation.y,
		0.0
	)

	camera_mount.rotation.y = lerp_angle(
		camera_mount.rotation.y,
		target_rotation.y,
		rotation_smoothing * delta
	)

	#var target_rotation := Vector3(
		#surfboard.global_rotation.x,
		#surfboard.global_rotation.y,
		#surfboard.global_rotation.z
	#)
#
	#camera_mount.global_rotation.x = lerp_angle(
		#camera_mount.global_rotation.x,
		#target_rotation.x,
		#rotation_smoothing * delta
	#)
#
	#camera_mount.global_rotation.y = lerp_angle(
		#camera_mount.global_rotation.y,
		#target_rotation.y,
		#rotation_smoothing * delta
	#)
#
	#camera_mount.global_rotation.z = lerp_angle(
		#camera_mount.global_rotation.z,
		#target_rotation.z,
		#rotation_smoothing * delta
	#)
