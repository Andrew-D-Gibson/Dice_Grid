extends Node2D

@export var time_between_spawns: float = 0.2
var time_since_last_spawn: float = 0

@export var dice_to_spawn: int = 5
var dice_scene := preload('res://Source/Dice/dice.tscn')

@export var dice_queue_spacing: int = 32
var dice_queue: Array[Dice] 


func _ready() -> void:
	Events.spawn_dice.connect(_spawn_dice)
	Events.remove_die_from_queue.connect(_remove_die_from_queue)
	Events.add_die_to_queue.connect(_add_die_to_queue)


func _spawn_dice(num_of_dice:int = 0) -> void:
	dice_to_spawn += num_of_dice


func _remove_die_from_queue(die: Dice):
	if die in dice_queue:
		dice_queue.erase(die)
	_update_dice_queue()
	

func _add_die_to_queue(die: Dice):
	die.randomize_value()
	die.can_be_held = true
	dice_queue.append(die)
	_update_dice_queue()
	
	
func _update_dice_queue():
	# Remove null entries
	# This shouldn't be necessary, but still
	dice_queue = dice_queue.filter(func(dice): return dice != null)
			
	# Update the dice desired locations
	for n in range(len(dice_queue)):
		dice_queue[n].set_home_location(global_position + Vector2(n * dice_queue_spacing, 0))
		


func _process(delta: float) -> void:
	if dice_to_spawn > 0 and time_since_last_spawn >= time_between_spawns:
		# Spawn a new die
		var new_dice = dice_scene.instantiate()
		dice_queue.append(new_dice)
		
		new_dice.position = global_position + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0) + Vector2(600, 0)
		new_dice.set_home_location(global_position + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0))
		new_dice.value = 5
		
		add_sibling(new_dice)
	
	
		dice_to_spawn -= 1
		time_since_last_spawn = 0
		
	time_since_last_spawn += delta
