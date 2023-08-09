extends CharacterBody2D

@export var tilemap: TileMap

const SPEED = 150.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
	
	var point = tilemap.local_to_map(get_global_mouse_position())
	var isReachable = get_global_mouse_position().distance_to(position) < (16 * 6)
	$Hit.position = to_local(tilemap.map_to_local(point))
	$Hit.visible = isReachable;
	
	if isReachable:
		if Input.is_action_just_pressed("player_place") and tilemap.get_cell_atlas_coords(0, point).x < 0:
			tilemap.place_tile(point, 1)
			tilemap.update_lightmap()
	
		if Input.is_action_just_pressed("player_break"):
			tilemap.place_tile(point, 0)
			tilemap.update_lightmap()
	
	if Input.is_action_just_pressed("player_resetpos"):
		resetpos()

	move_and_slide()

func resetpos():
	position = Vector2(randf() * tilemap.width * 16, tilemap.height)
