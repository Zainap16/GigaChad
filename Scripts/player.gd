extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount

@export var sens_horizontal :float = 0.2
@export var sens_vertical :float = 0.2
@onready var visuals: Node3D = $visuals


@export var surfboard: RigidBody3D
@export var player_anchor: Marker3D
var is_on_surfboard:= false

var can_move := false
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

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
			var input_dir := Input.get_vector(
				"left",
				"right",
				"forward",
				"backward"
			)

			var direction := (
				transform.basis *
				Vector3(input_dir.x, 0, input_dir.y)
			).normalized()

			if direction:
				player_velocity.x = direction.x * SPEED
				player_velocity.z = direction.z * SPEED

		velocity = board_velocity + player_velocity

		move_and_slide()

		return
	# normal movement when not surfing...
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
func mount_surfboard() -> void:

	is_on_surfboard = true

	global_transform = player_anchor.global_transform
