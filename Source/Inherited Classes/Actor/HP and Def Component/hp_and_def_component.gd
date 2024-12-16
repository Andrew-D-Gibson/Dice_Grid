class_name HP_and_Def_Component
extends Node2D

signal death() 

@export_category("Health")
var health: int
@export var starting_health: int
@export var max_health: int

@export_category("Defense")
var defense: int
@export var starting_defense: int


func _ready() -> void:
	health = starting_health
	defense = starting_defense
	

func take_damage(amount: int) -> void:
	if defense > amount:
		change_defense(-amount)
	else:
		amount -= defense	# Decrease the damage by the defense
		defense = 0
		change_health(-amount)


func change_health(amount: int) -> void:
	health += amount
	
	# Clamp the health so this same function can be used for healing and damage
	health = clampi(health, 0, max_health)
	
	if health <= 0:
		death.emit()
	
	
func change_defense(amount: int) -> void:
	defense += amount
	defense = clampi(defense, 0, defense)
