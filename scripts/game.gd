extends Node2D

@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0.5, 0.8, 1.0))
	get_window().title = "Game"
