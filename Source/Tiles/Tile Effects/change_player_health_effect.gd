extends Effect

## Positive heals, negative damages
@export var health_change_amount: int = 4

func play(_dice_value: int = 0) -> void:
	Events.change_player_health.emit(health_change_amount)
