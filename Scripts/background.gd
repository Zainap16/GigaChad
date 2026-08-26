extends Node2D

@export var speed: float = 100.0

@onready var bg1: Sprite2D = $Background1
@onready var bg2: Sprite2D = $Background2


func _ready():
	setup_background()
	get_viewport().size_changed.connect(setup_background)


func setup_background():
	var screen_size = get_viewport_rect().size

	# Get the original image size
	var texture_size = bg1.texture.get_size()

	# Scale the image to fill the screen
	var scale_factor = max(
		screen_size.x / texture_size.x,
		screen_size.y / texture_size.y
	)

	bg1.scale = Vector2(scale_factor, scale_factor)
	bg2.scale = Vector2(scale_factor, scale_factor)

	# Get the scaled width
	var background_width = texture_size.x * scale_factor

	bg1.position = Vector2(0, 0)
	bg2.position = Vector2(background_width, 0)


func _process(delta):
	var background_width = bg1.texture.get_size().x * bg1.scale.x

	bg1.position.x -= speed * delta
	bg2.position.x -= speed * delta

	if bg1.position.x <= -background_width:
		bg1.position.x = bg2.position.x + background_width

	if bg2.position.x <= -background_width:
		bg2.position.x = bg1.position.x + background_width
