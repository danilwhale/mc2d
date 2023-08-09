extends TileMap

@export var width := 256
@export var height := 64

@export var lightmap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	if load_level():
		return
	
	for i in width:
		for j in height:
			place_tile(Vector2i(i, j), 1 if j >= height / 2 else 0)
	
	update_lightmap()

func place_tile(point: Vector2i, type: int):
	if type < 1:
		set_cell(0, point, 0)
	else:
		set_cell(0, point, 0, Vector2i(0, 0) if point.y == height / 2 else Vector2i(1, 0))
	

func update_lightmap():
	lightmap.generate_map(width, height)

func load_level():
	if not FileAccess.file_exists("level.dat"):
		return false
	
	var file = FileAccess.open("level.dat", FileAccess.READ)
	
	for i in width:
		for j in height:
			var b = file.get_8()
			place_tile(Vector2i(i, j), b)
	
	update_lightmap()
	file.close()
	
	return true;

func save_level():
	var file = FileAccess.open("level.dat", FileAccess.WRITE)
	
	for i in width:
		for j in height:
			file.store_8(0 if get_cell_atlas_coords(0, Vector2i(i, j)).x < 0 else 1)
	
	file.close()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_level()
