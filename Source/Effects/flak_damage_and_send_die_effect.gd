extends Effect

@export var damage_amount: int = 1

func play(effect_variables: Dictionary) -> Dictionary:
	# First remove null entries from our list of targets (they may have died)
	for i in range(len(effect_variables['targets'])-1, -1, -1):
		if not effect_variables['targets'][i]:
			effect_variables['targets'].remove_at(i)
			
	# If there's no target, return the die to the player
	if len(effect_variables['targets']) == 0:
		Globals.player.add_die_to_queue(effect_variables['die_used'], true)
		return effect_variables
		
	var activator_grid_location = effect_variables['activating_node'].host_cell.grid_location
	print(activator_grid_location)
	var surrounding_tiles = Globals.player.grid.get_all_surrounding_tiles(activator_grid_location)
	print(surrounding_tiles)
	
	effect_variables['die_used'].attack_tween(Globals.targeted_enemy, damage_amount + len(surrounding_tiles))

	return effect_variables
