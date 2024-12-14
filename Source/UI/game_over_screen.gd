extends Control

func _ready() -> void:
	Events.game_over.connect(_game_over)
	self.visible = false
	
	
func _game_over() -> void:
	self.visible = true
