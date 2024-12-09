class_name Player
extends Node2D


@export var max_health: int = 25
@export var health: int = 25
@export var defense: int = 0

func _ready() -> void:
	Events.change_player_health.connect(_change_health)
	Events.damage_player.connect(_take_damage)
	
	_update_ui()
	
	
func _change_health(amount: int) -> void:
	health += amount
	
	# Clamp the health so this same function can be used for healing and damage
	health = clampi(health, 0, max_health)
	
	# Update the health label
	_update_ui()
	
	# Handle player death
	if health == 0:
		_player_death()
	
	
func _change_defense(amount: int) -> void:
	defense += amount
	defense = clampi(defense, 0, defense)
	
	# Update the defense label
	_update_ui()


func _take_damage(amount: int) -> void:
	if defense > amount:
		defense -= amount
	else:
		amount -= defense
		defense = 0
		health -= amount
		
	_update_ui()
	
	

func _update_ui() -> void:
	$"Health Label".text = 'Player Health: ' + str(health) + '/' + str(max_health)
	$"Defense Label".text = 'Player Defense: ' + str(defense)


func _player_death() -> void:
	pass
