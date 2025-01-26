extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var level = -1
func _process(delta: float) -> void:
	var level_actuel = get_parent().get_node("FIN").level
	if level != level_actuel :
		level = level_actuel
		var ezrg = "lv"
		ezrg += str(level)
		$AnimatedSprite2D.play(ezrg)
