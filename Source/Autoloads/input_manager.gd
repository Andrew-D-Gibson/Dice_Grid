extends Node

func _input(event: InputEvent) -> void:
	# Handle application quiting on "Esc"
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
