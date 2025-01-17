extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	print(Globals.targeted_enemy)
	effect_variables['targets'] = [Globals.targeted_enemy]
	return effect_variables
