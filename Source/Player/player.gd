class_name Player
extends Actor

@export_category("Components")
@export var grid: Grid
@export var dice_queue_offset: Vector2 = Vector2(0, 100)
@export var dice_queue_spacing: int = 32
@export var starting_dice: int = 5
@export var starting_dice_spawn_delay: float = 0.2


@export_category("UI")
@export var health_label: Label
@export var defense_label: Label


func _ready() -> void:
	Globals.player = self
	
	hp_and_def.death.connect(_death)
	
	# Create a function to spawn the starting dice
	var spawn_die = func spawn_die():
		var new_dice = dice_scene.instantiate()
		new_dice.position = global_position + dice_queue_offset + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0) + Vector2(600, 0)
		new_dice.set_home_location(global_position + dice_queue_offset + Vector2((len(dice_queue)-1) * dice_queue_spacing, 0))
		
		add_die_to_queue(new_dice)
		#new_dice.value = Array([3,5]).pick_random()
		get_tree().get_current_scene().add_child(new_dice)
		
	# Spawn the starting dice with a tween
	var tween = get_tree().create_tween()
	for i in range(starting_dice):
		tween.tween_callback(spawn_die).set_delay(starting_dice_spawn_delay)

	_update_ui()
	
	
func add_die_to_queue(die: Dice, preserve_value: bool = false) -> void:
	die.can_be_held = true
	super(die, preserve_value)
	_update_dice_queue_locations()


func remove_die_from_queue(die: Dice) -> void:
	super(die)
	_update_dice_queue_locations()


func _update_dice_queue_locations() -> void:
	# Update the dice desired locations in the world
	for n in range(len(dice_queue)):
		dice_queue[n].set_home_location(global_position + dice_queue_offset + Vector2(n * dice_queue_spacing, 0))
	

func _update_ui() -> void:
	health_label.text = "Player Health: " + str(hp_and_def.health) + " / " + str(hp_and_def.max_health)
	defense_label.text = "Player Defense: " + str(hp_and_def.defense)


func _death() -> void:
	get_tree().paused = true
	Events.game_over.emit()
