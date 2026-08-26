extends CharacterBody3D

@export_category("Movement")
@export var chase_speed := 7.0
@export var acceleration := 5.0
@export var turn_speed := 3.0

@export_category("Escape")
@export var escape_time := 4.0
@export var escape_distance := 10.0
@onready var escape_label: Label = $CanvasLayer/EscapeLabel
var escape_timer := 0.0
var escaping := false

var player:Node3D
var shark:CharacterBody3D

@export_category("SharkAttack")
@export var bite_cooldown := 1.0
var can_bite := true

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
		


func _process(delta: float) -> void:
	match state:
		SharkState.CHASING:
			chase_player(delta)
			update_escape_timer(delta)
		SharkState.ATTACKING:
			attack_player()
		SharkState.ESCAPED:
			pass
	pass
	

func bite_player() -> void:

	if not can_bite:
		return

	can_bite = false
	state = SharkState.ATTACKING

	print("CHOMP!")

	attack_player()

	await get_tree().create_timer(bite_cooldown).timeout

	can_bite = true
func attack_player():
	if state == SharkState.ATTACKING:
		return

	state = SharkState.ATTACKING

	print("SHARK BITES PLAYER!")

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


func update_escape_timer(delta: float) -> void:

	var distance := global_position.distance_to(
		player.global_position
	)

	if distance > escape_distance:

		escaping = true
		escape_timer += delta
		var remaining := escape_time - escape_timer

		escape_label.text = "ESCAPE: %.1f" % remaining
		escape_label.visible = true
	else:

		escaping = false
		escape_timer = 0.0
		escape_label.visible = false
	if escape_timer >= escape_time:

		escape_shark()
		
##Kills shark once outrun
func escape_shark():
	queue_free()


func _on_detection_area_body_entered(body: Node3D) -> void:
	
	if body.name == "Surfboard":
		bite_player()
		
#		might add a timer and then show game over screen
		print("You Lose")
