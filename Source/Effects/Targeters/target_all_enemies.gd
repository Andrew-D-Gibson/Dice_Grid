extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['targets'] = get_tree().get_nodes_in_group('enemies')
	return effect_variables
