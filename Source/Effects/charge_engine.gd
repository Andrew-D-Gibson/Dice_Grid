extends Effect

@export var amount: int = -1000

func play(effect_variables: Dictionary) -> Dictionary:
	if amount == -1000:
		Globals.player.engine_charger.change_charge(effect_variables['die_used'].value)
		
	else:
		Globals.player.engine_charger.change_charge(amount)
		
	return effect_variables
