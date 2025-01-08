extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	# If we don't have a target, give the dice to the player
	if not effect_variables['targets'] or not effect_variables['targets'][0]:
		Globals.player.add_die_to_queue(effect_variables['die_used'])
	else:
		effect_variables['die_used'].send_tween(effect_variables['targets'][0])
	
	return effect_variables
