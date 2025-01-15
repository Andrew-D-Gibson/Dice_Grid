extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['targets'] = [Globals.targeted_enemy]
	return effect_variables
