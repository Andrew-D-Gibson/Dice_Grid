extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	for dice in Globals.player.dice_queue:
		dice.randomize_value()
		
	return effect_variables
