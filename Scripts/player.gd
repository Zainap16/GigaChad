extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount

@export var sens_horizontal :float = 0.2
@export var sens_vertical :float = 0.2
@onready var visuals: Node3D = $visuals


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
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

		
func _physics_process(_delta: float) -> void:
	##"How many seconds has the game been running?"
	#var time = Time.get_ticks_msec() / 1000.0
##	i think get_wave_height calcs the Y value
	#var water_height = wave_manager.get_wave_height(global_position, time)
	#global_position.y = water_height
	#print(water_height)
	
#	check whether maves are higher or lower all sides of the player
	#var center = wave_manager.get_wave_height(
		#global_position,
		#time
	#)
	#var front = wave_manager.get_wave_height(
		#global_position + Vector3.FORWARD,
		#time
	#)
#
	#var back = wave_manager.get_wave_height(
		#global_position + Vector3.BACK,
		#time
	#)
#
	#var left = wave_manager.get_wave_height(
		#global_position + Vector3.LEFT,
		#time
	#)
#
	#var right = wave_manager.get_wave_height(
		#global_position + Vector3.RIGHT,
		#time
	#)
	
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		

		#if ani_player.current_animation != "walking":
			#anim_play.play("walking")
		#visuals.look_at(direction + direction) 
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
#		if anim_play.current_animation != "idle":
#		anim_play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
