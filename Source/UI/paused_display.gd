extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = false
	
	Events.game_pause_toggled.connect(_toggle_showing)


func _toggle_showing() -> void:
	visible = !visible
