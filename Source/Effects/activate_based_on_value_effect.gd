extends Effect

var tiles_to_activate_queue: Array[Tile] = []
var currently_activating: bool = false

func play(effect_variables: Dictionary) -> Dictionary:
	var pip_value = effect_variables['die_used'].value
	var activator_grid_location = effect_variables['activating_node'].host_cell.grid_location
	tiles_to_activate_queue.append_array(Globals.player.grid.get_surrounding_tiles_by_pip_value(pip_value, activator_grid_location))
	
	for tile in tiles_to_activate_queue:
		tile.highlight.visible = true
		tile.activation_completed.connect(_process_next_tile_activation)
	
	if not currently_activating:
		currently_activating = true
		_process_next_tile_activation()
	
	return effect_variables


func _process_next_tile_activation() -> void:
	# Stop the activation chain if there's no more tiles in the queue
	if len(tiles_to_activate_queue) < 1:
		currently_activating = false
		return
		
	# Check for locked out tiles and remove them from the list
	# Then re-highlight all queued tiles
	# This keeps tiles highlighted that are queued multiple times and would
	# usually de-highlight themselves after their first activation
	for i in range(len(tiles_to_activate_queue)-1, -1, -1):
		if tiles_to_activate_queue[i].host_cell.locked_out:
			tiles_to_activate_queue[i].highlight.visible = false
			tiles_to_activate_queue.remove_at(i)
			continue
			
		tiles_to_activate_queue[i].highlight.visible = true
		
		
	# Grab the first tile in the tile activation queue
	var tile = tiles_to_activate_queue.pop_front()
	
	# Get an available die in the player's dice queue and check that 
	# it's not locked out, being held, or otherwise being moved.
	var available_die: Dice = null
	for die in Globals.player.dice_queue:
		if die.locked_out_time_remaining <= 0 and not die.being_held and not die.being_tweened:
			available_die = die
			break
	
	# If there's not an available die, delete the tile activation queue
	if not available_die:
		# De-highlight everything
		tile.highlight.visible = false
		for t in tiles_to_activate_queue:
			t.highlight.visible = false
			
		# Clear the queue
		tiles_to_activate_queue = []
		currently_activating = false
		return
		
	# Remove the available die from the player's dice queue
	Globals.player.remove_die_from_queue(available_die)
	
	## If needed, change its value to properly activate
	#if not tile.activation_node.criteria_satisfied(available_die):
	
	# Change the value to the maximum acceptable value
	available_die.set_value(tile.activation_node.acceptable_values[-1])
	
	
	# Send it to the necessary tile
	available_die.activate_tile_tween(tile)
