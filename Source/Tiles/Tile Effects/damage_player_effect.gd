extends Effect

@export var damage_amount: int = 6

func play(_dice_value: int = 0) -> void:
	Events.damage_player.emit(damage_amount)
