extends Effect

@export var damage_amount: int = 5
@export var dice_scene: PackedScene


func play(effect_variables: Dictionary) -> Dictionary:
	# If there's no target, destroy the die
	if len(effect_variables['targets']) == 0 or effect_variables['targets'][0] == null:
		effect_variables['die_used'].destroy()
		effect_variables['die_used'] = null
		return effect_variables
		
	# If there's multiple targets, we need to create die to send at them
	var dice_to_send = []
	dice_to_send.push_back(effect_variables['die_used'])
	
	while len(effect_variables['targets']) != len(dice_to_send):
		var new_dice = dice_scene.instantiate()
		new_dice.global_position = effect_variables['die_used'].global_position
		new_dice.value = effect_variables['die_used'].value
		
		get_tree().get_current_scene().add_child(new_dice)
		dice_to_send.push_back(new_dice)
		
	
	# Now shoot each dice at each target
	for i in range(len(effect_variables['targets'])):
		dice_to_send[i].attack_tween(effect_variables['targets'][i], damage_amount)
	
	return effect_variables
