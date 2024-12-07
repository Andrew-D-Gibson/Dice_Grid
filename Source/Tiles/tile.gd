class_name tile
extends Node2D


var being_held: bool = false


func _process(_delta: float) -> void:
	if being_held:
		position = get_global_mouse_position()
		

func check_mouse_pickup() -> void:
	if $Sprite2D.get_rect().has_point(to_local(get_global_mouse_position())):
		being_held = true
		
		
func drop() -> void:
	# Assign to a grid cell if this is the tile being held
	if being_held:
		pass
	
	being_held = false
