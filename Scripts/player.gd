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

var camera_yaw := 0.0
var camera_pitch := 0.0

@export_category("Camera Limits")
##Pitch = looking UP and DOWN.
@export var min_pitch := -45.0
@export var max_pitch := 40.0


##Yaw = looking LEFT and RIGHT.
@export var min_yaw := -60.0
@export var max_yaw := 90.0

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

@export_category("Balance")
@export var max_balance_tilt := 25.0
@export var balance_sensitivity := 1.0
@onready var camera_3d: Camera3D = $camera_mount/SpringArm3D/Camera3D


##Think of balance as: 0 = perfectly balanced 10 = slightly unstable 20 = very unstable 25+ = falling
var balance := 0.0

##makes camera move slowly the lower the number is
@export var rotation_smoothing := 5.0
func _ready() -> void:
	WaveManager.player = self
	print("PLAYER REGISTERED")
	print("WaveManager.player = ", WaveManager.player)
	camera_3d.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	mount_surfboard()
	print("CAMERA FOUND: ", camera_3d)
	#print("CAMERA CURRENT: ", camera.current)


func _input(event):

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if event is InputEventMouseMotion:

		# LEFT / RIGHT
		camera_yaw -= event.relative.x * sens_horizontal
		camera_yaw = clamp(
			camera_yaw,
			min_yaw,
			max_yaw
		)

		# UP / DOWN
		camera_pitch -= event.relative.y * sens_vertical
		camera_pitch = clamp(
			camera_pitch,
			min_pitch,
			max_pitch
		)

		# Apply rotation
		camera_mount.rotation.y = deg_to_rad(camera_yaw)
		camera_mount.rotation.x = deg_to_rad(camera_pitch)


func _process(delta: float) -> void:

	if not is_on_surfboard:
		return

	if can_move:
		update_balance_lean(delta)


## --------------------------------
## SURFING LEAN
## --------------------------------

func update_balance_lean(delta: float) -> void:

	var board_up := surfboard.global_transform.basis.y

	var balance_x := board_up.z
	var balance_z := -board_up.x

	var correction := Vector3(
		balance_x,
		0.0,
		balance_z
	)

	visuals.rotation.x = lerp(
		visuals.rotation.x,
		correction.x,
		5.0 * delta
	)

	visuals.rotation.z = lerp(
		visuals.rotation.z,
		correction.z,
		5.0 * delta
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
