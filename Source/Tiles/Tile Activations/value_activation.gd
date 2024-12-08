extends Activation

@export var acceptable_values: Array[int] = []

func criteria_satisfied(dice: Dice = null) -> bool:
	return dice.value in acceptable_values
