extends RigidBody3D

@export_category("Buoyancy")
##apply an upward force --> simulate "floating"
@export var buoyancy_strength := 25.0
##resistance the water applies to the surf board. So the faster you are the more resistance is applied
@export var water_drag := 2.0
@export_category("Wave Following")
@export var wave_follow_strength := 5.0
@export var wave_follow_damping := 1.5

@export_category("Wave Movement")
##moves the surboard forward. Bascially.
@export var wave_push := 8.0
@export var wave_rotation_strength := 20.0
##Resistance applied.
@export var wave_rotation_damping := 5.0

@onready var front_probe: Marker3D = $BuoyancyPoints/FrontProbe
@onready var back_probe: Marker3D = $BuoyancyPoints/BackProbe
@onready var left_probe: Marker3D = $BuoyancyPoints/LeftProbe
@onready var right_probe: Marker3D = $BuoyancyPoints/RightProbe

@export_category("Player")
@export var player:Node3D
@export var player_weight: float  = 3.0
@export var weight_shift_strength := 1.0

@export_category("Steering")
##Rotational Speed A/D
@export var steering_torque := 10.0
##Force applied when pushing forward
@export var acceleration_force := 25.0
##break force/No reverse
@export var brake_force := 40.0


@export_category("Speed")
@export var max_speed := 15.0

@export_category("Sinking")
@export var sinking_force := 20.0
@export var sinking_torque := 5.0
@export var sink_depth := 5.0
var is_sinking := false

@onready var restart_timer: Timer = $"../RestartTimer"

func _physics_process(_delta: float) -> void:

	if is_sinking:
		apply_sinking()
		return
	apply_buoyancy(front_probe)
	apply_buoyancy(back_probe)
	apply_buoyancy(left_probe)
	apply_buoyancy(right_probe)
	
	apply_wave_following()
	apply_wave_rotation()
	apply_water_drag()
	apply_wave_force()
	apply_player_weight_shift()
	apply_player_acceleration()
	apply_player_steering()
	limit_speed()
	#print(
		#"Y: ", global_position.y,
		#" | Vel: ", linear_velocity.y,
		#" | Sleeping: ", sleeping
	#)
		
##Apply an upward force at this particular point.
func apply_buoyancy(probe: Marker3D) -> void:

	var point := probe.global_position

	var water_height := WaveManager.get_wave_height(point)

	var depth := water_height - point.y

	if depth <= 0.0:
		return

	var force := Vector3.UP * depth * buoyancy_strength

	var offset := point - global_position

	apply_force(force, offset)

##slows the board in water
func apply_water_drag() -> void:

	var submersion := get_submersion_factor()

	if submersion <= 0.0:
		return

	var drag_force := -linear_velocity * water_drag * submersion
#means a board that's 25% submerged gets roughly 25% of the drag, while a fully submerged board gets 100%.
	apply_central_force(drag_force)

##pushes the board horizontally
func apply_wave_force() -> void:

	var wave_velocity := WaveManager.get_wave_velocity()
	var wave_direction := WaveManager.get_wave_direction()

	var board_velocity := linear_velocity

	var relative_velocity := wave_velocity - board_velocity

	var relative_speed := relative_velocity.dot(wave_direction)
#compares waves and board speeds, if waves is faster than the surfboard then the surboard gets pushed more forward
#else 
# have negative relative_speed and no push happens
	if relative_speed <= 0.0:
		return

	var submersion := get_submersion_factor()

	if submersion <= 0.0:
		return

	var force := (
		wave_direction
		* relative_speed
		* wave_push
		* submersion
	)

	apply_central_force(force)
	
##gives you one water height for the board
func get_average_water_height() -> float:

	var probes := [
		front_probe,
		back_probe,
		left_probe,
		right_probe
	]

	var total := 0.0
#How high is the mathematical wave at each of these four positions?" via wavemanager
	for probe in probes:
		total += WaveManager.get_wave_height(
			probe.global_position
		)

	return total / probes.size()
##The buoyancy/spring system
func apply_wave_following() -> void:

	var water_height :float = get_average_water_height()

	var height_difference := water_height - global_position.y

	var force_strength := (
		height_difference * wave_follow_strength
		- linear_velocity.y * wave_follow_damping
	)

	apply_central_force(Vector3.UP * force_strength)
	
##if submerge push positve direction, else negative no force applied
func get_submersion_factor() -> float:

	var probes := [
		front_probe,
		back_probe,
		left_probe,
		right_probe
	]

	var submerged := 0.0

	for probe in probes:

		var point :Vector3= probe.global_position
		var water_height : float = WaveManager.get_wave_height(point)

		if water_height > point.y:
			submerged += 1.0

	return submerged / probes.size()
##tilting
func apply_wave_rotation() -> void:

	#var water_normal := WaveManager.get_wave_normal(global_position)
	var water_normal := get_board_water_normal()

	var board_up := global_transform.basis.y

	var rotation_axis := board_up.cross(water_normal)
	var rotation_error := rotation_axis.length()

	if rotation_error < 0.001:
		return

	rotation_axis = rotation_axis.normalized()

	var torque := rotation_axis * rotation_error * wave_rotation_strength

	apply_torque(torque)

##four probes to determine the water surface underneath
func get_board_water_normal() -> Vector3:

	var front_height := WaveManager.get_wave_height(
		front_probe.global_position
	)

	var back_height := WaveManager.get_wave_height(
		back_probe.global_position
	)

	var left_height := WaveManager.get_wave_height(
		left_probe.global_position
	)

	var right_height := WaveManager.get_wave_height(
		right_probe.global_position
	)

	var front_pos := front_probe.global_position
	var back_pos := back_probe.global_position
	var left_pos := left_probe.global_position
	var right_pos := right_probe.global_position

	front_pos.y = front_height
	back_pos.y = back_height
	left_pos.y = left_height
	right_pos.y = right_height

	var front_back := back_pos - front_pos
	var left_right := right_pos - left_pos

	var normal := front_back.cross(left_right)

	return normal.normalized()

##Have player weight impact the surboard
func apply_player_weight_shift() -> void:

	var relative_position := (
		player.global_position - global_position
	)

	var weight_force := Vector3.DOWN * player_weight

	var torque := (
		relative_position.cross(weight_force)
		* weight_shift_strength
	)

	apply_torque(torque)

##Steering function A/D
func apply_player_steering() -> void:

	if not player.can_move:
		return

	var input := Input.get_axis("right", "left")

	if input == 0.0:
		return

	var up := global_transform.basis.y

	apply_torque(
		up * input * steering_torque
	)

##Moves surfboard and breaking
func apply_player_acceleration() -> void:

	if not player.can_move:
		return
	var input := Input.get_axis("backward", "forward")

	var forward := -global_transform.basis.z

	if input > 0.0:
		# W - accelerate
		apply_central_force(
			forward * input * acceleration_force
		)

	elif input < 0.0:
		# S - brake
		var forward_speed := linear_velocity.dot(forward)

		if forward_speed > 0.0:
			apply_central_force(
				-forward * brake_force
			)
			
#accelerate backwards
	#var input := Input.get_axis("backward", "forward")
#
	#if input == 0.0:
		#return
#
	#var forward := -global_transform.basis.z
#
	#apply_central_force(
		#forward * input * acceleration_force
	#)

func apply_sinking() -> void:

	apply_central_force(
		Vector3.DOWN * sinking_force
	)

	apply_torque(
		global_transform.basis.x * sinking_torque
	)

	var water_height := WaveManager.get_wave_height(global_position)

	if global_position.y < water_height - sink_depth:
		finish_sinking()

func finish_sinking() -> void:

	print("PLAYER LOST")

	set_physics_process(false)
	
	restart_timer.start()

func start_sinking() -> void:

	if is_sinking:
		return

	is_sinking = true

	print("SURFBOARD IS SINKING")


func limit_speed() -> void:

	var horizontal_velocity := Vector3(
		linear_velocity.x,
		0.0,
		linear_velocity.z
	)

	var speed := horizontal_velocity.length()

	if speed <= max_speed:
		return

	horizontal_velocity = horizontal_velocity.normalized() * max_speed

	linear_velocity.x = horizontal_velocity.x
	linear_velocity.z = horizontal_velocity.z
