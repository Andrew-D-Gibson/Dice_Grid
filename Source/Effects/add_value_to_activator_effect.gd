extends Effect

@export var amount: int = 1

func _ready() -> void:
	if get_parent() is EnemyAction and get_parent().amount != -1:
		amount = get_parent().amount
		

func play(effect_variables: Dictionary) -> Dictionary:
	if effect_variables['die_used'].value < 6:
		effect_variables['die_used'].set_value(effect_variables['die_used'].value + 1)
	return effect_variables
