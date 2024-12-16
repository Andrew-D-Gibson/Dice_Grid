extends Effect

@export var defense_amount: int = 3

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['actor'].change_defense(defense_amount)
	return effect_variables
