extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	for dice in Globals.player.dice_queue:
		if dice.value == 1:
			dice.set_value(5)
		elif dice.value == 5:
			dice.set_value(1)
		
	return effect_variables
