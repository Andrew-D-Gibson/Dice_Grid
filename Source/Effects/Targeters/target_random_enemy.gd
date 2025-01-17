extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	var random_enemy = get_tree().get_nodes_in_group('enemies').pick_random()
	effect_variables['targets'] = [random_enemy]

	return effect_variables
