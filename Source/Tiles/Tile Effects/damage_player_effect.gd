extends Effect

@export var damage_amount: int = 6

func play(_die: Dice = null) -> void:
	Events.damage_player.emit(damage_amount)
