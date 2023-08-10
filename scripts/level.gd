extends TileMap

@export var width := 256
@export var height := 64
@export var zombie_count := 10

@export var lightmap: TileMap

const ZOMBIE = preload('res://scenes/zombie.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn N amount of zombies
	for z in zombie_count:
		var zombie = ZOMBIE.instantiate()
		zombie.position = Vector2(randf() * width * 16, -height * 16)
		get_parent().add_child.call_deferred(zombie)
	
	# if level is exists and was loaded, don't generate
	if load_level():
		return
	
	# very basic generation
	for i in width:
		for j in height:
			place_tile(Vector2i(i, j), 1 if j >= height / 2 else 0)
	
	# update lights
	update_lightmap()

func place_tile(point: Vector2i, type: int):
	# if type isn't solid, just clear cell
	if type < 1:
		set_cell(0, point, 0)
	else:
		# replicating rubydung-y style by setting grass tile only at half height y
		set_cell(0, point, 0, Vector2i(0, 0) if point.y == height / 2 else Vector2i(1, 0))
	
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
			file.store_8(0 if get_cell_atlas_coords(0, Vector2i(i, j)).x < 0 else 1)
	
	file.close()

func _notification(what):
	# save level on exit
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_level()
