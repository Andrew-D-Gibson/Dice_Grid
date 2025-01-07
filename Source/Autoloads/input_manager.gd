extends Node

func _ready() -> void:
	# Make this unpausable so we can always quit out
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func _input(event: InputEvent) -> void:
	# Handle application quiting on "Esc"
	if event.is_action_pressed('Quit'):
		get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('Pause'):
		get_tree().paused = !get_tree().paused
		Events.game_pause_toggled.emit()
		
	if event.is_action_pressed('Dev_Console'):
		Events.dev_console_toggled.emit()
