extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['die_used'].destroy()
	effect_variables['die_used'] = null
	return effect_variables
