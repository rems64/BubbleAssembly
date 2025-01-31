@tool
extends ProgressBar

func _process(delta):
	modulate = get_parent().get_parent().color
