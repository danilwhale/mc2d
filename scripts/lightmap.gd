extends TileMap

@export var tilemap: TileMap

func generate_map(width: int, height: int):
	# clear earlier shadows
	clear()
	
	for i in width:
		for j in height:
			# if tile at (i, j) is solid
			if tilemap.get_cell_atlas_coords(0, Vector2i(i, j)).x > -1:
				# go down and set shadows under (i, j)
				for k in range(j + 1, height):
					# check if tile is not solid or tile above is not solid too
					if  tilemap.get_cell_atlas_coords(0, Vector2i(i, k)).x < 0 or \
						tilemap.get_cell_atlas_coords(0, Vector2i(i, k - 1)).x < 0:
						# and place shadow at (i, k)
						set_cell(0, Vector2i(i, k), 0, Vector2i(0, 0))
				break
