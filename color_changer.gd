extends Node2D

@export var color: Color
@export var process_duration: float = 2.
@export var process_duration_random: float = 1.

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
			if bubble[0] == null:
				processing_bubbles.erase(bubble)
				continue
			bubble[0].reparent(get_tree().get_current_scene())
			var bub = bubble[0].get_child(0);
			if (bub.modulate == Color.DIM_GRAY):
				pass
			elif (bub.modulate == Color.WHITE):
				bub.modulate = color
			else:
				bub.modulate = Color(min(bub.modulate.r+color.r, 1), min(bub.modulate.g+color.g, 1), min(bub.modulate.b+color.b, 1))
				if (bub.modulate == Color.WHITE):
					bub.modulate = Color.DIM_GRAY #Color.BLACK
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
		if body.held || body.in_held_block || body.currently_processed:
			return
		for bubble in processing_bubbles:
			if bubble[0]==body:
				return
		
		var duration = randf_range(process_duration-process_duration_random, process_duration+process_duration_random)
		#body.reparent(self)
		
		processing_bubbles.push_back([body, duration, duration, body.collision_layer])
		var dp = 1.5*(area_out.global_position - area_in.global_position)
		body.position += dp
		#body.freeze = true;
		body.hide()
		body.collision_layer = 0
		body.currently_processed = true
