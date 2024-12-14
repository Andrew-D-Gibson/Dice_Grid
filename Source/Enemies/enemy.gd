class_name Enemy
extends Node2D

@export_category("Components")
@export var hp_and_def: HP_and_Def_Component

@export_category("UI")
@export var health_label: Label
@export var defense_label: Label

var dice_queue: Array[Dice]


func _ready() -> void:
	hp_and_def.death.connect(_death)
	_update_ui()
	
	
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
	queue_free()
	
	
func add_die_to_queue(die: Dice) -> void:
	dice_queue.push_back(die)
	die.desired_position = global_position
	#die.visible = false
	
	
func _act() -> void:
	# Only act if we can spend a die
	if len(dice_queue) == 0:
		return
		
	var die_used = dice_queue.pop_front()
	die_used.visible = true
		
	var possible_actions = $"Possible Actions Parent".get_children()
	var action = possible_actions.pick_random()
	assert(action is Enemy_Action)
	
	action.act(self, die_used)
