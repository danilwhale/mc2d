extends TileMap

@export var tilemap: TileMap
var lightmap = []

func generate_map(width: int, height: int):
	# clear earlier shadows
	clear()
	lightmap.clear()
	lightmap.resize(width)
	
	for i in width:
		for j in height:
			# if tile at (i, j) is solid
			if tilemap.get_cell_atlas_coords(0, Vector2i(i, j)).x > -1:
				# add shadow level to lightmap
				lightmap[i] = j
				# go down and set shadows under (i, j)
				for k in range(j + 1, height):
					# check if tile is not solid or tile above is not solid too
					if  tilemap.get_cell_atlas_coords(0, Vector2i(i, k)).x < 0 or \
						tilemap.get_cell_atlas_coords(0, Vector2i(i, k - 1)).x < 0:
						# and place shadow at (i, k)
						set_cell(0, Vector2i(i, k), 0, Vector2i(0, 0))
				break

func is_lit(x: int, y: int):
	if x < 0 or x >= len(lightmap):
		return true
	return y <= lightmap[x]
