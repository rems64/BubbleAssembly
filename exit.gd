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

func check_1(body, blocks) -> bool:
	print("check_1")
	if blocks.size() != 1: return false
	var body2 = blocks[0]
	var haut = body if (body.global_position.y < body2.global_position.y) else body2
	var bas = body2 if (body.global_position.y < body2.global_position.y) else body
	print(haut.get_child(0).modulate)
	print(bas.get_child(0).modulate)
	print()
	return bas.get_child(0).modulate == Color.RED && haut.get_child(0).modulate == Color.WHITE

func check_2(body, blocks) -> bool:
	if body.get_child(0).modulate != Color(1, 0, 1): return false
	if body.voisinGauche == null: return false
	if body.voisinGauche.get_child(0).modulate != Color.BLUE: return false
	if body.voisinGauche.voisinHaut == null: return false
	if body.voisinGauche.voisinHaut.get_child(0).modulate != Color.RED: return false
	return true

func next_level():
	print("next level!")
	level += 1
	if level == 3:
		get_tree().change_scene_to_file("res://end_menu.tscn")

func _on_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		if body.held || body.in_held_block:
			return
				
		var assembly = body.get_parent().dijkstra(body)
		if is_exit:
			print("exit")
			print(level)
			if level == 0:
				if check_0(body, assembly): next_level()
			elif level == 1:
				if check_1(body, assembly): next_level()
			elif level == 2:
				if check_2(body, assembly): next_level()

		body.queue_free()
		for block in assembly:
			block.queue_free()
