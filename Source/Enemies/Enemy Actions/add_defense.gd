extends Enemy_Action

@export var def_amount: int = 3

func act(acting_enemy: Enemy, die_used: Dice) -> void:
	acting_enemy.change_defense(def_amount)
	Events.add_die_to_queue.emit(die_used)
