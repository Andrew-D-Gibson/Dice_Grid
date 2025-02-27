extends Node2D

@export_category("Encounters")
@export var current_state: int
@export var game_states: Array[GameState] 

@export_category("Components")
@export var player: Player
@export var targeting_computer: TargetingComputer


func _ready() -> void:
	_load_game_state(current_state)
	
	Events.load_game_state.connect(_load_game_state)
	Events.make_jump_transition.connect(_load_next_game_state)
	
	
func _load_game_state(state_num: int) -> void:
	# Check for a valid game state to load
	if state_num < 0 or state_num >= game_states.size():
		print('Attempting to load a non-existent game state: ' + str(state_num))
		return
		
	current_state = state_num
	
	# Set up the player's health and defense
	player.hp_and_def.starting_health = game_states[state_num].player_health
	player.hp_and_def.health = game_states[state_num].player_health
	player.hp_and_def.max_health = game_states[state_num].player_max_health
	player.hp_and_def.starting_defense = game_states[state_num].player_defense
	player.hp_and_def.defense = game_states[state_num].player_defense
	
	# Set up the player's dice
	for child in get_tree().get_current_scene().get_children():
		if child is Dice:
			child.destroy()
	player.dice_queue = []
	player.dice_to_spawn = game_states[state_num].num_of_dice
	
	# Set up the player's grid
	player.grid.clear_grid()
	player.grid.create_and_populate_grid(game_states[state_num].tile_locations)
	
	player._update_ui()
	
	
	# Set up the enemies if there's an encounter
	var existing_enemies = get_tree().get_nodes_in_group('enemies')
	for enemy in existing_enemies:
		enemy.hp_and_def.health = 0
		enemy.queue_free()
		
	if game_states[state_num].encounter:
		_spawn_enemies(game_states[state_num].encounter.enemies)
		
		
	# Re-target the targeting computer
	targeting_computer.attempt_retarget()
	
	# Reset the engine charge
	player.engine_charger.reset_charge()


func _load_next_game_state() -> void:
	current_state += 1
	if current_state >= game_states.size():
		current_state -= 1
		
	_load_game_state(current_state)
	

func _spawn_enemies(encounter_enemies: Array[PackedScene]) -> void:
	if len(encounter_enemies) == 0:
		return
		
	var spacing: int = 600
	var enemy_spacing = spacing / float(len(encounter_enemies) + 1)
	
	for i in range(len(encounter_enemies)):
		var enemy = encounter_enemies[i].instantiate()
		enemy.position = Vector2(-(spacing / float(2)) + (enemy_spacing * (i+1)), -80)
		add_child(enemy)
