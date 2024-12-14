extends Enemy_Action

@export var heal_amount: int = 2

func act(acting_enemy: Enemy) -> void:
	acting_enemy.change_health(heal_amount)
