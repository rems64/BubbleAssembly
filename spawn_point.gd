extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

signal spawn_bubble
func gogogo():
	var bulle = preload("res://bubulle.tscn").instantiate()
	bulle.visible = true
	get_parent().add_child(bulle)
	bulle.global_position = global_position
	spawn_bubble.emit()

var t = 0
var next_t = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	if t>next_t:
		t = 0
		next_t = randf_range(2, 4)
		gogogo()
