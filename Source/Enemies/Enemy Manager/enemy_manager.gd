extends Node2D

@export var encounter: Encounter
@export var enemies: Array[Enemy]

func _ready() -> void:
	# Connect signals
	Events.damage_random_enemy.connect(_damage_random_enemy)
	
	_spawn_encounter()
	
	
func _spawn_encounter() -> void:
	for enemy_scene in encounter.enemies:
		var enemy = enemy_scene.instantiate()
		enemies.append(enemy)
		add_child(enemy)


func _damage_random_enemy(amount: int) -> void:
	var random_enemy = enemies.pick_random()
	random_enemy.take_damage(amount)
