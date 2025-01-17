extends Effect

var tiles_to_activate_queue: Array[Tile] = []
var currently_activating: bool = false

func play(effect_variables: Dictionary) -> Dictionary:
	# Add one to the activator die
	effect_variables['die_used'].set_value(effect_variables['die_used'].value + 1)
	
	# Get this tile's location
	var activator_grid_location = effect_variables['activating_node'].host_cell.grid_location
	
	# Check that a tile exists and can be activated with this die
	# If this fails, send to a random enemy
	if Globals.player.grid.cell_array[activator_grid_location.x].has(activator_grid_location.y - 1):
		if Globals.player.grid.cell_array[activator_grid_location.x][activator_grid_location.y - 1].occupying_tile:
			if Globals.player.grid.cell_array[activator_grid_location.x][activator_grid_location.y - 1].occupying_tile.activation_node.criteria_satisfied(effect_variables['die_used']):
				effect_variables['die_used'].activate_tile_tween(Globals.player.grid.cell_array[activator_grid_location.x][activator_grid_location.y - 1].occupying_tile)
				return effect_variables
			
		
	var random_enemy = get_tree().get_nodes_in_group('enemies').pick_random()
	if not random_enemy:
		Globals.player.add_die_to_queue(effect_variables['die_used'])
	else:
		effect_variables['die_used'].send_tween(random_enemy)
	
	return effect_variables
