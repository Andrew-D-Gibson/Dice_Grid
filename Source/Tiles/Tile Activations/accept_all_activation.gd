extends Activation

func criteria_satisfied(dice: Dice = null) -> bool:
	return true


func get_valid_value() -> int:
	return Array([1,2,3,4,5,6]).pick_random()
