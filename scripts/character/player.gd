extends CharacterBody2D

@export var tilemap: TileMap
@onready var gui = $Camera2D/GUILayer/GUI
@onready var paint_tile_prev = $Camera2D/GUILayer/GUI/PaintTile

const SPEED = 150.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var paint_tile = Tiles.STONE.tex

func _ready():
	resetpos()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	# convert mouse position to tilemap position
	var point = tilemap.local_to_map(get_global_mouse_position()) 
	# check if it is reachable
	var isReachable = get_global_mouse_position().distance_to(position) < (16 * 6)
	
	# move hit preview position to world cell position
	$Hit.position = to_local(tilemap.map_to_local(point))
	# hide it if position is not reachable
	$Hit.visible = isReachable;
	
	# if position is reachable then
	if isReachable:
		# check if user pressed player_place and cell under position is empty
		if Input.is_action_just_pressed("player_place") and tilemap.get_tile(point) < 0:
			# then place cell and update lights
			tilemap.place_tile(point, paint_tile)
			tilemap.update_lightmap()
		
		# if user wants to break cell
		if Input.is_action_just_pressed("player_break") and tilemap.get_tile(point) >= 0:
			# then break cell and update lights
			tilemap.destroy_tile(point)
			tilemap.update_lightmap()
	
	# if user wants to reset position
	if Input.is_action_just_pressed("player_resetpos"):
		# we just reset player position :)
		resetpos()
	
	if Input.is_action_just_pressed("player_spawn"):
		tilemap.spawn_zombie(position)

func _input(event):
	if event is InputEventKey:
		if not event.pressed: return
		
		if event.keycode == KEY_1:
			paint_tile = Tiles.STONE.tex
		elif event.keycode == KEY_2:
			paint_tile = Tiles.DIRT.tex
		elif event.keycode == KEY_3:
			paint_tile = Tiles.COBBLESTONE.tex
		elif event.keycode == KEY_4:
			paint_tile = Tiles.PLANKS.tex
		elif event.keycode == KEY_5:
			paint_tile = Tiles.SAPLING.tex
		
		var x = paint_tile % 16
		var y = paint_tile / 16

		paint_tile_prev.texture.region.position.x = x * 16
		paint_tile_prev.texture.region.position.y = y * 16

func resetpos():
	position = Vector2(randf() * tilemap.width * 16, tilemap.height)
