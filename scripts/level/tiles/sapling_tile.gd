extends Tile
class_name SaplingTile

func tick(level: TileMap, x: int, y: int):
	var below = level.get_tile(Vector2i(x, y + 1))
	
	if not level.is_lit(x, y) or (below != Tiles.DIRT.tex and below != Tiles.GRASS.tex):
		level.place_tile(Vector2i(x, y), 0)

func is_light_blocker():
	return false

func is_solid():
	return false
