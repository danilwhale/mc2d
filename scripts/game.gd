extends Node2D

const VERSION_STRING = "0.0.1a"

# Called when the node enters the scene tree for the first time.
func _ready():
	# make more rubydung-y sky
	RenderingServer.set_default_clear_color(Color(0.5, 0.8, 1.0))
	# make window more nostalgic by making title more rubydung-y
	get_window().title = "mc2d"
