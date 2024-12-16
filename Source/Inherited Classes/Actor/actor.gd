class_name Actor
extends Node2D

@export var hp_and_def: HP_and_Def_Component

var dice_queue: Array[Dice]
@export var dice_scene: PackedScene


func change_health(amount: int) -> void:
	hp_and_def.change_health(amount)
	_update_ui()
	
	
func change_defense(amount: int) -> void:
	hp_and_def.change_defense(amount)
	_update_ui()
	

func take_damage(amount: int) -> void:
	hp_and_def.take_damage(amount)
	_update_ui()


func add_die_to_queue(die: Dice, preserve_value: bool = false) -> void:
	if not preserve_value:
		die.randomize_value()
	dice_queue.append(die)
	die.set_home_location(global_position)
	_update_ui()


func remove_die_from_queue(die: Dice) -> void:
	if die in dice_queue:
		dice_queue.erase(die)
	_update_ui()
	

func _update_ui() -> void:
	# Should handle displaying hp, def, and the dice queue
	pass
