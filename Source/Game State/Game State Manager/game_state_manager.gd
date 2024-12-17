extends Node2D

@export_category("Encounter")
@export var game_state: Game_State

@export_category("Components")
@export var player: Player


func _ready() -> void:
	# Set up the player
	player.grid.create_and_populate_grid(game_state.tile_locations)
	
	# Set up the enemies if there's an encounter
	if game_state.encounter:
		_spawn_enemies(game_state.encounter.enemies)
	


func _spawn_enemies(encounter_enemies: Array[PackedScene]) -> void:
	if len(encounter_enemies) == 0:
		return
		
	var spacing: int = 500
	var enemy_spacing = spacing / float(len(encounter_enemies) + 1)
	
	for i in range(len(encounter_enemies)):
		var enemy = encounter_enemies[i].instantiate()
		enemy.position = Vector2(192, -(spacing / float(2)) + (enemy_spacing * (i+1)))
		add_child(enemy)
