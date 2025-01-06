extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	for dice in Globals.player.dice_queue:
		dice.randomize_value()
		dice.small_shake()
		
	return effect_variables
