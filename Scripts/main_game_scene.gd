extends Node3D
@export var player: CharacterBody3D
@onready var player_anchor: Marker3D = $Surfboard/PlayerAnchor
@onready var restart_timer: Timer = $RestartTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



## Called every frame. 'delta' is the elapsed time since the previous frame.


#snap player to surboard
func place_player_on_board() -> void:
	#player.global_transform = player_anchor.global_transform
	print("Snap player")


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
