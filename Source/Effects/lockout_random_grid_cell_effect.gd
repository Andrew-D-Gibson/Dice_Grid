extends Effect

@export var lockout_modifier_scene: PackedScene

func play(effect_variables: Dictionary) -> Dictionary:
	# Randomly grab a row then column from the player's grid
	# Note that this isn't fully random for non-standard grid shapes
	var random_row = Globals.player.grid.cell_array.keys().pick_random()
	var random_col = Globals.player.grid.cell_array[random_row].keys().pick_random()
	var random_cell = Globals.player.grid.cell_array[random_row][random_col]
	
	var lockout_modifier = lockout_modifier_scene.instantiate()
	random_cell.add_child(lockout_modifier)
	random_cell.add_modifier(lockout_modifier)
	
		
	return effect_variables
