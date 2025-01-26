extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bubbles = get_overlapping_bodies()
	var traction = global_transform.x.normalized();
#
	for bubble in bubbles:
		if (bubble.held || bubble.in_held_block):
			continue
		if get_instance_id() in bubble.conveyors_data:
			if bubble.conveyors_data[get_instance_id()] >= Engine.get_frames_drawn():
				continue
		var others = bubble.get_parent().dijkstra(bubble)
		others.push_back(bubble)
		var mid = Vector2.ZERO
		for o in others:
			mid += o.global_position
		mid /= others.size()
		
		var correction = Vector2(0, to_local(mid).y).rotated(rotation)
		for o in others:
			if (get_instance_id() in bubble.conveyors_data) && (bubble.conveyors_data[get_instance_id()] < Engine.get_frames_drawn()):
				var force = (traction - 0.01*correction).normalized() * 100 * delta
				#bubble.move_and_collide(force)
				o.position += force
			o.conveyors_data[get_instance_id()] = Engine.get_frames_drawn()
