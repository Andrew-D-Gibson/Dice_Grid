extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['targets'] = Array([Globals.player])
	return effect_variables
