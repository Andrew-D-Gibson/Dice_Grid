extends Effect

@export var amount: int = -1

func _ready() -> void:
	if get_parent() is EnemyAction and get_parent().amount != -1:
		amount = get_parent().amount
		

func play(effect_variables: Dictionary) -> Dictionary:
	for dice in effect_variables['actor'].dice_queue:
		if dice.value == 1:
			dice.set_value(effect_variables['die_used'].value)
	return effect_variables
