extends Control

func _ready() -> void:
	self.visible = false
	Events.game_over.connect(_game_over)
	
	
func _game_over() -> void:
	self.visible = true
