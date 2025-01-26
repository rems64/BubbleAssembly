extends Area2D

@export var is_exit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("body entered")
	if (body is RigidBody2D):
		if body.held || body.in_held_block:
			return
		
		body.queue_free()
		var assembly = body.get_parent().dijkstra(body)
		for block in assembly:
			block.queue_free()
