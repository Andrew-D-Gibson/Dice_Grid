extends Enemy_Action

@export var heal_amount: int = 2

func act(acting_enemy: Enemy, die_used: Dice) -> void:
	acting_enemy.change_health(heal_amount)
	Events.add_die_to_queue.emit(die_used)
