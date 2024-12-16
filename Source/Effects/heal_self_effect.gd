extends Effect

@export var heal_amount: int = 4

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['actor'].change_health(heal_amount)
	return effect_variables
