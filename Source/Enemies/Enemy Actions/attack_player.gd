extends Enemy_Action

@export var attack_amount: int = 2

func act(_acting_enemy: Enemy) -> void:
	Events.damage_player.emit(attack_amount)
