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
		if (bubble.currently_processed):
			continue
		var correction = Vector2(0, to_local(bubble.position).y).rotated(rotation)
		var force = (traction - 0.01*correction).normalized() * 100 * delta
		#bubble.move_and_collide(force)
		bubble.position += force
