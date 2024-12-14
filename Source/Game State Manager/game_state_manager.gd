extends Node2D

@export_category("Encounter")
@export var game_state: Game_State

@export_category("Components")
@export var grid: Grid


func _ready() -> void:
	Events.damage_random_enemy.connect(_damage_random_enemy)

	# Set up the player
	grid.create_and_populate_grid(game_state.tile_locations)
	
	# Set up the enemies if there's an encounter
	if game_state.encounter:
		_spawn_enemies(game_state.encounter.enemies)
	


func _spawn_enemies(encounter_enemies: Array[PackedScene]) -> void:
	if len(encounter_enemies) == 0:
		return
		
	var enemy_spacing = 360 / (len(encounter_enemies) + 1)
	
	for i in range(len(encounter_enemies)):
		var enemy = encounter_enemies[i].instantiate()
		enemy.position = Vector2(192, -180 + (enemy_spacing * (i+1)))
		add_child(enemy)


func _damage_random_enemy(amount: int) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	# The list could be empty, 
	# so stop if there's not a potential enemy to hit
	if len(enemies) == 0:
		return
	
	var random_enemy = enemies.pick_random()
	random_enemy.take_damage(amount)
