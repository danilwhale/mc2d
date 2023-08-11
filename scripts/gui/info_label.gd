extends Label

@onready var template = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = template % Engine.get_frames_per_second()
