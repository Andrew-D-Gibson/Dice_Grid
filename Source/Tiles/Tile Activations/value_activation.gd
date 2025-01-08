extends Activation

@export var acceptable_values: Array[int] = []

func criteria_satisfied(dice: Dice = null) -> bool:
	return dice.value in acceptable_values


func get_valid_value() -> int:
	return acceptable_values.pick_random()
