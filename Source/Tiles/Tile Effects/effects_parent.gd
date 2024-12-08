class_name Effects_Parent
extends Node2D

func play(dice_value:int = 0):
	for child_effect in get_children():
		if child_effect is Effect:
			child_effect.play(dice_value)
