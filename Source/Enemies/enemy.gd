class_name Enemy
extends Node2D

@export_category("Components")
@export var hp_and_def: HP_and_Def_Component

@export_category("UI")
@export var health_label: Label
@export var defense_label: Label



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
	
	
func _act() -> void:
	var possible_actions = $"Possible Actions Parent".get_children()
	var action = possible_actions.pick_random()
	assert(action is Enemy_Action)
	action.act(self)
