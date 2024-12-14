extends Enemy_Action

@export var attack_amount: int = 2

func act(_acting_enemy: Enemy, die_used: Dice) -> void:
	Events.damage_player.emit(attack_amount)
	Events.add_die_to_queue.emit(die_used)
