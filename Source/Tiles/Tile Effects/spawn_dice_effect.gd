extends Effect

## A value of 0 creates dice equivalent to the value on the activator dice 
@export var num_of_dice: int = 1

func play(dice_value: int = 0) -> void:
	if num_of_dice == 0:
		num_of_dice = dice_value
		
	Events.spawn_dice.emit(num_of_dice)
