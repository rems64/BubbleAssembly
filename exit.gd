extends Area2D

@export var is_exit: bool = false
@export var level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_0(body, blocks) -> bool:
	print(body.get_child(0).modulate)
	print(Color.YELLOW)
	return body.get_child(0).modulate == Color.YELLOW

func next_level():
	print("next level!")
	level += 1

func _on_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		if body.held || body.in_held_block:
			return
		
		print("output")
		
		var assembly = body.get_parent().dijkstra(body)
		if is_exit:
			print("exit")
			if level == 0:
				print("level0")
				if (check_0(body, assembly)):
					print("check0")
					next_level()

		body.queue_free()
		for block in assembly:
			block.queue_free()
