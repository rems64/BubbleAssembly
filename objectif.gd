extends Node2D

@onready var fin = $FIN;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@onready var level = -1
func _process(delta: float) -> void:
	var level_actuel = $FIN.level
	if level != level_actuel :
		level = level_actuel
		$AnimatedSprite2D.apparence.play("lv"+level)
