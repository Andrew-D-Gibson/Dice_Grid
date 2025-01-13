class_name Enemy
extends Actor

var action_list: Array[EnemyAction]
var currently_acting: bool = false
@export var action_indicator: Sprite2D

@export_category("UI")
@export var hp_bar: TextureProgressBar

func _ready() -> void:
	generate_action_list()
	hp_and_def.death.connect(_death)
	_update_ui()


func _process(delta: float) -> void:
	if len(dice_queue) > 0 and not currently_acting:
		_reroll_die_for_action()


func generate_action_list() -> void:
	# Sum up the choice likelihoods
	var action_weights_sum: float = 0
	for action in $"Possible Actions Parent".get_children():
		if action is EnemyAction:
			action_weights_sum += action.likelihood_weight

	# Randomly choose 6 actions picking from our weighted list
	for i in range(6):
		var choice_threshold = randf_range(0, action_weights_sum)
		for action in $"Possible Actions Parent".get_children():
			if action is EnemyAction:
				if choice_threshold > action.likelihood_weight:
					choice_threshold -= action.likelihood_weight
				else:
					action_list.append(action)
					break
				
				
func _update_ui() -> void:
	# Set the health bar
	hp_bar.value = hp_and_def.health / float(hp_and_def.max_health)
	$"HP Progress Bar/HP Label".text = str(hp_and_def.health)
	
	# Set the defense indicator and label
	$"HP Progress Bar/Def Indicator/Def Label".text = str(hp_and_def.defense)
	if hp_and_def.defense == 0:
		$"HP Progress Bar/Def Indicator".visible = false
	else:
		$"HP Progress Bar/Def Indicator".visible = true
		
	# Set the dice queue display
	for i in range($GridContainer.get_child_count()):
		$GridContainer.get_child(i).visible = len(dice_queue)-1 > i
		
	# Set up the action indicator sprites
	for i in range(6):
		if action_list[i].intent_texture:
			$"Action Indicator".get_child(i).texture = action_list[i].intent_texture
		else:
			$"Action Indicator".get_child(i).texture = null


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
	_update_ui()
	
	
func remove_die_from_queue(die: Dice) -> void:
	die.visible = true
	super(die)
	_update_ui()


func _reroll_die_for_action() -> void:
	currently_acting = true
	
	var die_used = dice_queue[0]
	die_used.visible = true
	die_used.reroll_tween(self)
	_update_ui()
	

func act(die_used: Dice):
	remove_die_from_queue(die_used)
	
	# Set up the effects dictionary for chaining effects
	var effect_dict = {
		'actor': self,
		'targets': null,
		'die_used': die_used,
		'activating_node': self
	}
	
	for effect in action_list[die_used.value-1].get_children(false):
		if effect is Effect:
			effect_dict = effect.play(effect_dict)
	
	currently_acting = false
	_update_ui()
