extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	Globals.player.add_die_to_queue(effect_variables['die_used'])
	return effect_variables
