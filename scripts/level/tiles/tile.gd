class_name Tile

var tex = 0

func _init(tex: int):
	self.tex = tex

func tick(level: TileMap, x: int, y: int):
	pass

func is_light_blocker():
	return true

func is_solid():
	return true
