extends Node3D
@export var player: CharacterBody3D
@onready var player_anchor: Marker3D = $Surfboard/PlayerAnchor
@onready var restart_timer: Timer = $RestartTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Player position BEFORE: ", player.global_position)
	print("Anchor position: ", player_anchor.global_position)

	place_player_on_board()

	print("Player position AFTER: ", player.global_position)


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

#snap player to surboard
func place_player_on_board() -> void:
	player.global_transform = player_anchor.global_transform
	print("Snap player")


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
