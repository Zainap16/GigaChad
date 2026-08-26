extends Node


var time: float = 0.0

@export_category("Wave Settings")
@export var wave_height: float = 1.0
@export var wave_frequency: float = 0.35
@export var wave_speed: float = 1.5


var player:Node3D

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_warning("Player not foundd")

func _process(delta: float) -> void:
	time += delta


func get_wave_height(pos: Vector3) -> float:

	var wave1 := sin(
		pos.x * wave_frequency
		+ time * wave_speed
	)

	var wave2 := sin(
		pos.z * (wave_frequency * 1.5)
		+ time * (wave_speed * 0.73)
	)

	var wave3 := sin(
		(pos.x + pos.z) * (wave_frequency * 0.7)
		+ time * (wave_speed * 0.53)
	)

	return (
		wave1 * 0.7 +
		wave2 * 0.3 +
		wave3 * 0.2
	) * wave_height

##The orientation of the surface. Think "tilting" of the surfboard. The normal is basically a vector perpendicular to the wave surface
func get_wave_normal(pos: Vector3) -> Vector3:

	var sample_distance := 0.1

	var center := get_wave_height(pos)

	var height_x := get_wave_height(
		pos + Vector3(sample_distance, 0, 0)
	)

	var height_z := get_wave_height(
		pos + Vector3(0, 0, sample_distance)
	)

	var slope_x := (height_x - center) / sample_distance
	var slope_z := (height_z - center) / sample_distance

	var normal := Vector3(
		-slope_x,
		1.0,
		-slope_z
	)

	return normal.normalized()

func get_wave_direction() -> Vector3:
	return Vector3(-1, 0, 0)


func get_wave_velocity() -> Vector3:
	return get_wave_direction() * wave_speed
