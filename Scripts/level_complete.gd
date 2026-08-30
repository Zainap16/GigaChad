extends Area3D

@onready var win_audio: AudioStreamPlayer = $WinAudio
@onready var victory_2: AudioStreamPlayer = $Victory2
@onready var fade: ColorRect = $UI/Fade


@export_category("Fade Settings")
@export var fade_in_duration := 1.0
@export var display_duration := 1.0
@export var fade_out_duration := 1.0


var victory_triggered := false


func _ready() -> void:

	# Start with the fade hidden
	fade.visible = false
	fade.modulate.a = 0.0


func _on_body_entered(body: Node3D) -> void:

	# Only react to the surfboard
	if body.name != "Surfboard":
		return

	# Prevent victory from triggering more than once
	if victory_triggered:
		return

	victory_triggered = true

	print("YOU WIN")

	# Play victory audio once
	win_audio.play()
	victory_2.play()

	# Start fade
	play_fade()


func play_fade() -> void:

	fade.visible = true
	fade.modulate.a = 0.0

	var tween := create_tween()

	# -------------------------
	# FADE IN
	# -------------------------

	tween.tween_property(
		fade,
		"modulate:a",
		1.0,
		fade_in_duration
	)

	# -------------------------
	# HOLD
	# -------------------------

	tween.tween_interval(display_duration)

	# -------------------------
	# FADE OUT
	# -------------------------

	tween.tween_property(
		fade,
		"modulate:a",
		0.0,
		fade_out_duration
	)

	# Hide after fade finishes
	tween.tween_callback(func():
		fade.visible = false
	)


func _on_body_exited(body: Node3D) -> void:
	pass
