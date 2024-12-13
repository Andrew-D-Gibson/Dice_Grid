class_name Enemy_Manager
extends Node2D

@export var encounter: Encounter
@export var enemies: Array[Enemy]

func _ready() -> void:
	# Connect signals
	Events.damage_random_enemy.connect(_damage_random_enemy)


func spawn_enemies(encounter_enemies: Array[PackedScene]) -> void:
	for enemy_scene in encounter_enemies:
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(0, -90)
		enemies.append(enemy)
		add_child(enemy)


func _damage_random_enemy(amount: int) -> void:
	var random_enemy = enemies.pick_random()
	random_enemy.take_damage(amount)
