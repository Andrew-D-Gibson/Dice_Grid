class_name Player
extends Actor

@export_category("Components")
@export var grid: Grid

@export var dice_queue_offset: Vector2 = Vector2(-50, 100)
@export var dice_queue_spacing: int = 32

@export var dice_to_spawn: int = 10
@export var dice_spawn_delay: float = 0.2
var time_since_last_die_spawn: float = 0


@export_category("UI")
@export var hp_bar: TextureProgressBar


func _ready() -> void:
	Globals.player = self
	hp_and_def.death.connect(_death)

	_update_ui()
	
	
func _process(delta: float) -> void:
	if dice_to_spawn > 0:
		if time_since_last_die_spawn > dice_spawn_delay:
			spawn_die()
			dice_to_spawn -= 1
			time_since_last_die_spawn = 0
			
		time_since_last_die_spawn += delta
	
	
func spawn_die() -> void:
	var new_dice = dice_scene.instantiate()
	new_dice.position = global_position + dice_queue_offset + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0) + Vector2(600, 0)
	new_dice.set_home_location(global_position + dice_queue_offset + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0))
	
	add_die_to_queue(new_dice)
	#new_dice.value = 5 #Array([3,5]).pick_random()
	new_dice.set_lockout_time(0)
	get_tree().get_current_scene().add_child(new_dice)
		
	
func add_die_to_queue(die: Dice, preserve_value: bool = false) -> void:
	die.can_be_held = true
	super(die, preserve_value)
	die.set_lockout_time(5)
	_update_dice_queue_locations()


func remove_die_from_queue(die: Dice) -> void:
	super(die)
	_update_dice_queue_locations()


func _update_dice_queue_locations() -> void:
	# Update the dice desired locations in the world
	for n in range(len(dice_queue)):
		dice_queue[n].set_home_location(global_position + dice_queue_offset + Vector2(n * dice_queue_spacing, 0))
	

func _update_ui() -> void:
	hp_bar.value = hp_and_def.health / float(hp_and_def.max_health)
	$"HP Progress Bar/HP Label".text = str(hp_and_def.health)
	
	$"HP Progress Bar/Def Indicator/Def Label".text = str(hp_and_def.defense)
	if hp_and_def.defense == 0:
		$"HP Progress Bar/Def Indicator".visible = false
	else:
		$"HP Progress Bar/Def Indicator".visible = true


func _death() -> void:
	get_tree().paused = true
	Events.game_over.emit()
