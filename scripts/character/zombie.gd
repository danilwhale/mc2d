extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var flip = false


func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# some very realistic ai
	if randf() > 0.99 and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if randf() > 0.995:
		flip = not flip
		$Head.flip_h = flip
	
	# flip velocity if zombie is flipped
	velocity.x = SPEED * (-1 if flip else 1)
	
	# move it.
	move_and_slide()
	
	# some goofy ahh animation from rd-132328
	var time = Time.get_ticks_msec() / 100
	var flip_axis = -1 if flip else 1
	
	$Head.rotation_degrees = rad_to_deg(sin(time * 0.83))
	
	$Arm0.rotation_degrees = rad_to_deg(sin(time * 0.662 + PI) * 2) * flip_axis
	$Arm1.rotation_degrees = rad_to_deg(sin(time * 0.662) * 2) * flip_axis
	
	$Leg0.rotation_degrees = rad_to_deg(sin(time * 0.662) * 1.4) * flip_axis
	$Leg1.rotation_degrees = rad_to_deg(sin(time * 0.662 + PI) * 1.4) * flip_axis
	
	
