extends TileMap

@export var width := 256
@export var height := 64
@export var zombie_count := 10

@export var lightmap: TileMap

@export var noise: FastNoiseLite

const ZOMBIE = preload('res://scenes/zombie.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn N amount of zombies
	for z in zombie_count:
		spawn_zombie(Vector2(randf() * width * 16, -height * 16))
	
	# if level is exists and was loaded, don't generate
	if load_level():
		return
	
	# perlin noise generation
	for i in width:
		var j = floor(abs(noise.get_noise_1d(i)) * height) / 2 + height / 2
		
		for k in range(j, height):
			if k >= j:
				place_tile(Vector2i(i, k), Tiles.DIRT.tex)
			elif k >= j + floor(abs(noise.get_noise_1d(k)) * height) / 8:
				place_tile(Vector2i(i, k), Tiles.STONE.tex)
		
		place_tile(Vector2i(i, j), Tiles.GRASS.tex)
	
	# update lights
	update_lightmap()

func spawn_zombie(point: Vector2):
	var zombie = ZOMBIE.instantiate()
	zombie.position = point
	get_parent().add_child.call_deferred(zombie)

func place_tile(point: Vector2i, type: int):
	if point.x < 0 or point.x >= width or point.y < 0 or point.y >= height:
		return
	# if type isn't solid, just clear cell
	if type < 1:
		set_cell(0, point, 0)
	else:
		var x = type % 16
		var y = type / 16
		set_cell(0, point, 0, Vector2i(x, y))

func get_tile(point: Vector2i):
	if point.x < 0 or point.x >= width or point.y < 0 or point.y >= height:
		return 0
	
	var cell = get_cell_atlas_coords(0, point)
	return cell.y * width + cell.x

# just shortcut to lightmap's function
func update_lightmap():
	lightmap.generate_map(width, height)

func load_level():
	# if no save exists, just generate new level
	if not FileAccess.file_exists("level.dat"):
		return false
	
	var file = FileAccess.open("level.dat", FileAccess.READ)
	
	# getting bytes from level.dat and placing them
	for i in width:
		for j in height:
			var b = file.get_8()
			place_tile(Vector2i(i, j), b)
	
	# update lights
	update_lightmap()
	
	file.close()
	
	return true;

func save_level():
	var file = FileAccess.open("level.dat", FileAccess.WRITE)
	
	# save level data to level.dat
	for i in width:
		for j in height:
			var v = get_cell_atlas_coords(0, Vector2i(i, j))
			var b = v.y * width + v.x

			if v.x < 0 or v.y < 0:
				file.store_8(0)
			else:
				file.store_8(b)
	
	file.close()

func _process(delta):
	for i in width * height / 400:
		var x = randi_range(0, width - 1)
		var y = randi_range(0, height - 1)
		
		var tile = Tiles.get_tile(get_tile(Vector2i(x, y)))
		if tile:
			tile.tick(self, x, y)

func _notification(what):
	# save level on exit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_level()
