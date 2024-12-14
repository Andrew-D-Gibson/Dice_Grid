extends Effect

@export var damage_amount: int = 5

func play(_die: Dice = null) -> void:
	Events.damage_random_enemy.emit(damage_amount)
