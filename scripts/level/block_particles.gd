extends GPUParticles2D

func emit(tex: int):
	var x = tex % 16
	var y = tex / 16
	print(x)
	print(y)
	
	texture = texture.duplicate()
	texture.region.position = Vector2(x * 16, y * 16)
	emitting = true
	$Timer.start()

static func create_emit(parent: Node, point: Vector2, tex: int):
	var emitter = preload("res://scenes/block_particles.tscn").instantiate()
	emitter.position = point
	parent.add_child(emitter)
	emitter.emit(tex)


func _on_timer_timeout():
	queue_free()
