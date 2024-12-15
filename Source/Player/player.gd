class_name Player
extends Node2D

@export_category("Components")
@export var hp_and_def: HP_and_Def_Component
@export var grid: Grid

@export_category("UI")
@export var health_label: Label
@export var defense_label: Label


func _ready() -> void:
	Events.change_player_health.connect(_change_health)
	Events.change_player_defense.connect(_change_defense)
	Events.damage_player.connect(_take_damage)
	
	hp_and_def.death.connect(_death)
	
	_update_ui()
	
	
func _change_health(amount: int) -> void:
	hp_and_def.change_health(amount)
	_update_ui()
	
	
func _change_defense(amount: int) -> void:
	hp_and_def.change_defense(amount)
	_update_ui()
	

func _take_damage(amount: int) -> void:
	hp_and_def.take_damage(amount)
	_update_ui()	


func _update_ui() -> void:
	health_label.text = "Player Health: " + str(hp_and_def.health) + " / " + str(hp_and_def.max_health)
	defense_label.text = "Player Defense: " + str(hp_and_def.defense)


func _death() -> void:
	get_tree().paused = true
	Events.game_over.emit()
