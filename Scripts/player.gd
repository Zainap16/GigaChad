extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount

@export var sens_horizontal :float = 0.2
@export var sens_vertical :float = 0.2
@onready var visuals: Node3D = $visuals

@onready var player_feet: Marker3D = $PlayerFeet

@export var surfboard: RigidBody3D
@export var player_anchor: Marker3D
var is_on_surfboard:= false

@export var can_move := false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@export_category("Limitations")
@export var surf_forward_limit := 1.5
@export var surf_backward_limit := 1.5
@export var surf_side_limit := 0.7
@export var surf_move_speed := 2.0

@export_category("Speed")
@export var max_speed := 15.0


@export_category("Shark Escape")
@export var escape_time := 4.0

var escape_timer := 0.0
var escaping_shark := false
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mount_surfboard()
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		##clamp(value, min_value, max_value)
		#camera_mount.rotation.y = clamp(camera_mount.rotation.y, deg_to_rad(-45), deg_to_rad(45))

#		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))

		
func _physics_process(delta: float) -> void:

	if is_on_surfboard:
		var board_velocity := get_board_velocity_at_player()
		var player_velocity := Vector3.ZERO

		if can_move:
			player_velocity = get_surf_velocity()
		velocity = board_velocity + player_velocity

		move_and_slide()
		limit_player_position()
		#update_shark_escape(delta)
		#update_camera_direction()
		return
	

##How fast is the board moving underneath me
func get_board_velocity_at_player() -> Vector3:

	var relative_position := (
		global_position - surfboard.global_position
	)

	var rotational_velocity := (
		surfboard.angular_velocity.cross(relative_position)
	)

	return (
		surfboard.linear_velocity
		+ rotational_velocity
	)

##Move surfboard
func surf_move(delta: float) -> void:

	var surf_input := get_surf_input()
	var board_forward := -surfboard.global_transform.basis.z
	var board_right := surfboard.global_transform.basis.x

	var movement := (
		board_right * surf_input.x
		+ board_forward * surf_input.y
	)

	# Move player relative to board
	global_position += movement * SPEED * delta
##Surf Velocity
func get_surf_velocity() -> Vector3:

	var surf_input := get_surf_input()

	var board_forward := -surfboard.global_transform.basis.z
	var board_right := surfboard.global_transform.basis.x

	var movement := (
		board_right * surf_input.x
		+ board_forward * surf_input.y
	)

	return movement * surf_move_speed

##Get player Input to move on surfboard.
func get_surf_input() -> Vector2:

	return Input.get_vector(
		"left",
		"right",
		"backward",
		"forward"
	)
##Snap player to surfboard
func mount_surfboard() -> void:

	is_on_surfboard = true

	var feet_offset := global_position - player_feet.global_position

	global_position = player_anchor.global_position + feet_offset

##Limit player movement on surfboard
func limit_player_position() -> void:
#I think this gets the board's area
	var local_position := surfboard.to_local(global_position)

#here's where the area retriction occurs
	local_position.z = clamp(
		local_position.z,
		-surf_forward_limit,
		surf_backward_limit
	)

	local_position.x = clamp(
		local_position.x,
		-surf_side_limit,
		surf_side_limit
	)

	global_position = surfboard.to_global(local_position)

func update_shark_escape(delta: float) -> void:

	if not escaping_shark:
		return

	var input := Input.get_axis("backward", "forward")

	# Player is accelerating forward
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
func update_camera_direction() -> void:

	var board_basis := surfboard.global_transform.basis

	var board_yaw := atan2(
		-board_basis.z.x,
		-board_basis.z.z
	)

	camera_mount.global_rotation.y = board_yaw
