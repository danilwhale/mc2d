extends Tile
class_name GrassTile

func tick(level: TileMap, x: int, y: int):
	if not level.is_lit(x, y):
		level.place_tile(Vector2i(x, y), Tiles.DIRT.tex)
	else:
		for i in 4:
			var xt = x + randi_range(0, 3) - 1
			var yt = y + randi_range(0, 3) - 1
			
			if level.get_tile(Vector2i(xt, yt)) == Tiles.DIRT.tex and level.is_lit(xt, yt):
				level.place_tile(Vector2i(xt, yt), Tiles.GRASS.tex)
				level.update_lightmap()
