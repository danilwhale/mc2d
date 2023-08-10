extends Tile
class_name SaplingTile

func tick(level: TileMap, x: int, y: int):
	var below = level.get_tile(Vector2i(x, y))

	if not level.is_lit(x, y) and below != Tiles.DIRT.tex and below != Tiles.GRASS.tex:
		level.place_tile(Vector2i(x, y), 0)

func is_light_blocker():
	return false
