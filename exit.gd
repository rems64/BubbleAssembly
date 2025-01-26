extends Area2D

@export var is_exit: bool = false
@export var level: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_0(body, blocks) -> bool:
	return body.modulate == Color.RED

func next_level():
	print("next level!")
	level += 1

func _on_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		if body.held || body.in_held_block:
			return
		
		var assembly = body.get_parent().dijkstra(body)
		if is_exit:
			if level==0:
				if (check_0(body, assembly)):
					next_level()

		body.queue_free()
		for block in assembly:
			block.queue_free()
