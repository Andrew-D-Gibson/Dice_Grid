extends Effect

@export var defense_amount: int = 6

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['die_used'].reroll_tween()
	return effect_variables
