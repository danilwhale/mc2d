extends TileMap

@export var tilemap: TileMap

func generate_map(width: int, height: int):
	var dark = 0.8
	
	clear()
	
	for i in width:
		for j in height:
			if tilemap.get_cell_atlas_coords(0, Vector2i(i, j)).x > -1:
				for k in range(j + 1, height):
					if  tilemap.get_cell_atlas_coords(0, Vector2i(i, k)).x < 0 or \
						tilemap.get_cell_atlas_coords(0, Vector2i(i, k - 1)).x < 0:
						set_cell(0, Vector2i(i, k), 0, Vector2i(0, 0))
				break
