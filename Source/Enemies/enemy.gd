class_name Enemy
extends Actor

var next_action: Node2D
var action_loading_time: float

@export_category("UI")
@export var health_label: Label
@export var defense_label: Label


func _ready() -> void:
	hp_and_def.death.connect(_death)
	
	for child in $"Possible Actions Parent".get_children(false):
		child.visible = false
	
	_choose_next_action()
	_update_ui()


func _process(delta: float) -> void:
	if len(dice_queue) > 0:
		action_loading_time -= delta
		
		if action_loading_time <= 0:
			_act()


func _update_ui() -> void:
	health_label.text = "Enemy Health: " + str(hp_and_def.health) + " / " + str(hp_and_def.max_health)
	defense_label.text = "Enemy Defense: " + str(hp_and_def.defense)


func _death() -> void:
	# Remove the die in reverse order so the indices work out
	for i in range(len(dice_queue)-1, -1, -1):
		var die = dice_queue[i]
		remove_die_from_queue(die)
		Globals.player.add_die_to_queue(die)
	queue_free()


func add_die_to_queue(die: Dice, preserve_value: bool = false) -> void:
	die.visible = false
	die.can_be_held = false
	super(die, preserve_value)
	
	
func remove_die_from_queue(die: Dice) -> void:
	die.visible = true
	super(die)


func _choose_next_action() -> void:
	var possible_actions = $"Possible Actions Parent".get_children(false)
	next_action = possible_actions.pick_random()
	
	if not next_action:
		return
		
	next_action.visible = true
	action_loading_time = next_action.action_loading_time


func _act() -> void:
	var die_used = dice_queue.pop_front()
	die_used.visible = true
	
	# Set up the effects dictionary for chaining effects
	var effect_dict = {
		'actor': self,
		'targets': null,
		'die_used': die_used,
		'activating_node': self
	}
	
	for effect in next_action.get_children(false):
		if effect is Effect:
			effect_dict = effect.play(effect_dict)
			
	next_action.visible = false
	
	_choose_next_action()
	_update_ui()
