extends Node2D
@onready var child = $bulle
var held_object = null
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)

func _on_pickable_clicked(object):
	if held_object == null:
		print("held object not null")
		object.pickup()
		held_object = object

func _unhandled_input(event) :
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var bulle = preload("res://bubulle.tscn").instantiate()
	#var bulle_instance = bulle.instance()
	#bulle.global_transform = child.global_transform
	add_child(bulle)
	bulle.clicked.connect(_on_pickable_clicked)
