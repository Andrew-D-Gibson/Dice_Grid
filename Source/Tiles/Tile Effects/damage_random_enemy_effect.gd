extends Effect

@export var damage_amount: int = 5

func play(_dice_value: int = 0) -> void:
	Events.damage_random_enemy.emit(damage_amount)
