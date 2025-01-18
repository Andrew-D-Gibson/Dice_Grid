class_name Enemy
extends Actor

var action_list: Array[EnemyAction]
var currently_acting: bool = false

@export var targeting_computer_image: Texture2D

@export_category('UI')
@export var action_indicator: Sprite2D
@export var default_health_bar_background: Texture2D
@export var shielded_health_bar_background: Texture2D

func _ready() -> void:
	generate_action_list()
	hp_and_def.death.connect(_death)
	#hp_and_def.hull_hit.connect(_hull_hit)
	#hp_and_def.shield_hit.connect(_shield_hit)
	_update_ui()
	
	var tween_time = randf_range(4, 8)
	var tween = get_tree().create_tween()
	tween.tween_property($Ship, 'global_position', $Ship.global_position + Vector2(0, 12), tween_time/2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Ship, 'global_position', $Ship.global_position, tween_time/2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
	
	
func _process(delta: float) -> void:
	if len(dice_queue) > 0 and not currently_acting:
		_reroll_die_for_action()


func generate_action_list() -> void:
	# Sum up the choice likelihoods
	var action_weights_sum: float = 0
	for action in $"Possible Actions Parent".get_children():
		if action is EnemyAction:
			action_weights_sum += action.likelihood_weight
			action_list.append(action)

	# Randomly choose 6 actions picking from our weighted list
	for i in range(6 - len(action_list)):
		var choice_threshold = randf_range(0, action_weights_sum)
		for action in $"Possible Actions Parent".get_children():
			if action is EnemyAction:
				if choice_threshold > action.likelihood_weight:
					choice_threshold -= action.likelihood_weight
				else:
					action_list.append(action)
					break
	
	action_list.shuffle()
	
				
func _update_ui() -> void:
	# Set the health bar
	$"Health and Shields Indicator/Health Bar".value = hp_and_def.health / float(hp_and_def.max_health)
	$"Health and Shields Indicator/Health Label".text = str(hp_and_def.health)
	
	# Set the defense indicator and label
	$"Health and Shields Indicator/Shields Label".text = str(hp_and_def.defense)
	if hp_and_def.defense == 0:
		$"Health and Shields Indicator".texture = default_health_bar_background
	else:
		$"Health and Shields Indicator".texture = shielded_health_bar_background
		
	# Set the dice queue display
	for i in range($GridContainer.get_child_count()):
		$GridContainer.get_child(i).visible = len(dice_queue)-1 > i
		
	# Set up the action indicator sprites
	for i in range(6):
		$"Action Indicator".get_child(i).get_child(0).text = ''
		if action_list[i].intent_texture:
			$"Action Indicator".get_child(i).texture = action_list[i].intent_texture
			
			if action_list[i].amount != -1:
				$"Action Indicator".get_child(i).get_child(0).text = str(action_list[i].amount)
		else:
			$"Action Indicator".get_child(i).texture = null


func _death() -> void:
	# Remove the die in reverse order so the indices work out
	for i in range(len(dice_queue)-1, -1, -1):
		var die = dice_queue[i]
		remove_die_from_queue(die)
		Globals.player.add_die_to_queue(die)
	
	Events.enemy_died.emit()
	queue_free()


func add_die_to_queue(die: Dice, preserve_value: bool = true) -> void:
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
	#die_used.reroll_tween(self)
	
	# Wait a beat and then check that we're still alive before acting
	await get_tree().create_timer(1).timeout
	if hp_and_def.health > 0:
		die_used.enemy_intent_tween(self)
		
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


func show_intent_info(action_num: int) -> void:
	print(action_num)


func _on_button_pressed() -> void:
	print('Button pushed')


#func _hull_hit() -> void:
	#var shader_material = $Ship.material as ShaderMaterial
	#shader_material.set_shader_parameter("flash_name", from_value)
	#tween.tween_property(shader_material, "shader_parameter/" + param_name, to_value, duration)
#
#func _shield_hit() -> void:
	#
	#
#func tween_shader_param(param_name: String, from_value: float, to_value: float, duration: float):
	#var shader_material = material as ShaderMaterial
	#shader_material.set_shader_parameter(param_name, from_value)
	#tween.tween_property(shader_material, "shader_parameter/" + param_name, to_value, duration)
