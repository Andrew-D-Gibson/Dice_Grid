extends Node

func _input(event):
	# Check left mouse input for tile pick up and drop
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			print('Mouse Pressed')
			get_tree().call_group("tiles", "check_mouse_pickup")
		else:
			print('Mouse Released')
			get_tree().call_group("tiles", "drop")
