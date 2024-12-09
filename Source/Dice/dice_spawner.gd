extends Node2D

@export var time_between_spawns: float = 0.2
var time_since_last_spawn: float = 0

@export var dice_to_spawn: int = 5
var dice_scene := preload('res://Source/Dice/dice.tscn')

@export var dice_queue_spacing: int = 32
@export var dice_queue: Array[Dice] 

func _ready() -> void:
	Events.spawn_dice.connect(_spawn_dice)
	Events.die_destroyed.connect(_update_dice_queue)


func _spawn_dice(num_of_dice:int = 0) -> void:
	dice_to_spawn += num_of_dice


func _update_dice_queue(dice: Dice = null):
	if dice:
		dice_queue.erase(dice)
		
	# Remove null entries
	dice_queue = dice_queue.filter(func(dice): return dice != null)
			
	# Update the dice desired locations
	for n in range(len(dice_queue)):
		dice_queue[n].desired_position = global_position + Vector2(n * dice_queue_spacing, 0)


func _process(delta: float) -> void:
	if dice_to_spawn > 0 and time_since_last_spawn >= time_between_spawns:
		_update_dice_queue()
		
		# Spawn a new die
		var new_dice = dice_scene.instantiate()
		add_sibling(new_dice)
		
		dice_queue.append(new_dice)
		
		new_dice.position = global_position + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0) + Vector2(200, 0)
		new_dice.desired_position = global_position + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0)
		
		dice_to_spawn -= 1
		time_since_last_spawn = 0
		
	time_since_last_spawn += delta
