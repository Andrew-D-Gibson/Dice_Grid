class_name Enemy
extends Node2D

@export var next_action: Enemy_Action
var action_loading_time: float

@export_category("Components")
@export var hp_and_def: HP_and_Def_Component

@export_category("UI")
@export var health_label: Label
@export var defense_label: Label

var dice_queue: Array[Dice]


func _ready() -> void:
	hp_and_def.death.connect(_death)
	_choose_next_action()
	_update_ui()


func _process(delta: float) -> void:
	if len(dice_queue) > 0:
		action_loading_time -= delta
		
		if action_loading_time <= 0:
			_act()


func change_health(amount: int) -> void:
	hp_and_def.change_health(amount)
	_update_ui()


func change_defense(amount: int) -> void:
	hp_and_def.change_defense(amount)
	_update_ui()


func take_damage(amount: int) -> void:
	hp_and_def.take_damage(amount)
	_update_ui()	


func _update_ui() -> void:
	health_label.text = "Enemy Health: " + str(hp_and_def.health) + " / " + str(hp_and_def.max_health)
	defense_label.text = "Enemy Defense: " + str(hp_and_def.defense)


func _death() -> void:
	for die in dice_queue:
		die.visible = true
		Events.add_die_to_queue.emit(die)
	queue_free()


func add_die_to_queue(die: Dice) -> void:
	dice_queue.push_back(die)
	die.set_home_location(global_position)
	die.visible = false


func _choose_next_action() -> void:
	var possible_actions = $"Possible Actions Parent".get_children()
	next_action = possible_actions.pick_random()
	action_loading_time = next_action.action_loading_time


func _act() -> void:		
	var die_used = dice_queue.pop_front()
	die_used.visible = true
	
	next_action.act(self, die_used)
	_choose_next_action()
