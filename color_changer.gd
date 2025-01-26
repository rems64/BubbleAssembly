extends Node2D

@export var color: Color
@export var process_duration: float = 3.
@export var process_duration_random: float = 2.

@onready var area_in: Area2D = $"Area In"
@onready var area_out: Area2D = $"Area Out"
@onready var progress_bar: ProgressBar = $ProgressBar

var processing_bubbles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(processing_bubbles.size())
	for bubble in processing_bubbles:
		if bubble[1] < 0:
			bubble[0].reparent(get_tree().get_current_scene())
			var bub = bubble[0].get_child(0);
			if (bub.modulate == Color.BLACK):
				pass
			elif (bub.modulate == Color.WHITE):
				bub.modulate = color
			else:
				bub.modulate = Color(min(bub.modulate.r+color.r, 1), min(bub.modulate.g+color.g, 1), min(bub.modulate.b+color.b, 1))
				if (bub.modulate == Color.WHITE):
					bub.modulate = Color.BLACK
			bubble[0].show();
			bubble[0].currently_processed = false
			bubble[0].collision_layer = bubble[3]
			processing_bubbles.erase(bubble)
			progress_bar.value = 0.
		else:
			bubble[1] -= delta
			progress_bar.value = 100.*(1-bubble[1]/bubble[2])

func _on_area_in_body_entered(body: Node2D) -> void:
	if (body is RigidBody2D):
		if body.held || body.currently_processed:
			return
		for bubble in processing_bubbles:
			if bubble[0]==body:
				return
		print("add")
		var duration = randf_range(process_duration-process_duration_random, process_duration+process_duration_random)
		processing_bubbles.push_back([body, duration, duration, body.collision_layer])
		#body.reparent(self)
		body.move_and_collide(area_out.global_position - body.global_position)
		body.freeze = true;
		body.hide()
		body.collision_layer = 0
		body.currently_processed = true
