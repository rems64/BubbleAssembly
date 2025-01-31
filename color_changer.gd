extends Node2D

@export var color: Color
@export var process_duration: float = 2.
@export var process_duration_random: float = 1.

@onready var area_in: Area2D = $"Area In"
@onready var area_out: Area2D = $"Area Out"
@onready var progress_bars: VBoxContainer = $VBoxContainer

var processing_bubbles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

signal spawn_bubble

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(processing_bubbles.size())
	for bubble in processing_bubbles:
		if bubble[1] < 0:
			if bubble[0] == null:
				processing_bubbles.erase(bubble)
				continue
			var scene = preload("res://bubulle.tscn")
			var scene_instance = scene.instantiate()
			scene_instance.set_name("scene")
			get_tree().get_current_scene().add_child(scene_instance)
			var bub = scene_instance.get_child(0);
			scene_instance.global_position = area_out.global_position
			bub.modulate = bubble[0]
			if (bub.modulate == Color.DIM_GRAY):
				pass
			elif (bub.modulate == Color.WHITE):
				bub.modulate = color
			else:
				bub.modulate = Color(min(bub.modulate.r+color.r, 1), min(bub.modulate.g+color.g, 1), min(bub.modulate.b+color.b, 1))
				if (bub.modulate == Color.WHITE):
					bub.modulate = Color.DIM_GRAY #Color.BLACK
			processing_bubbles.erase(bubble)
			bubble[3].value = 0.
			bubble[3].queue_free()
			spawn_bubble.emit()
			
		else:
			bubble[1] -= delta
			bubble[3].value = 100.*(1-bubble[1]/bubble[2])

func _on_area_in_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		if body.held || body.in_held_block || body.currently_processed:
			return
		
		var duration = randf_range(process_duration-process_duration_random, process_duration+process_duration_random)
		#body.reparent(self)
		var pb = ProgressBar.new()
		pb.show_percentage = false
		pb.modulate = color
		progress_bars.add_child(pb)
		processing_bubbles.push_back([body.get_child(0).modulate, duration, duration, pb])
		var dp = 1.5*(area_out.global_position - area_in.global_position)
		body.free()
		#body.position += dp
		##body.freeze = true;
		#body.hide()
		#body.collision_layer = 0
		#body.currently_processed = true
