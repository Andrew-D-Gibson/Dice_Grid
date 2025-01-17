extends Effect

@export var defense_amount: int = 6

func _ready() -> void:
	if get_parent() is EnemyAction and get_parent().amount != -1:
		defense_amount = get_parent().amount
		

func play(effect_variables: Dictionary) -> Dictionary:
	effect_variables['actor'].change_defense(defense_amount)
	return effect_variables
