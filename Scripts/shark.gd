extends CharacterBody3D

@export_category("Movement")
@export var chase_speed := 7.0
@export var acceleration := 5.0
@export var turn_speed := 3.0

@export_category("Target")

var player:Node3D
enum SharkState {
	CHASING,
	ATTACKING,
	ESCAPED
}

var state := SharkState.CHASING

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_warning("Player not foundd")


func _physics_process(delta: float) -> void:

	if player == null:
		return

	chase_player(delta)

func _process(delta: float) -> void:
	match state:
		SharkState.CHASING:
			chase_player(delta)
		SharkState.ATTACKING:
			attack_player()
		SharkState.ESCAPED:
			pass
	pass
	

func attack_player():
	print("ATTACK PLAYER")
	
	pass
func chase_player(delta: float) -> void:

	if not player:
		return

	var direction := (
		player.global_position - global_position
	).normalized()

	velocity = velocity.move_toward(
		direction * chase_speed,
		acceleration * delta
	)

	move_and_slide()

	# Face player
	look_at(
		global_position + direction,
		Vector3.UP
	)
