extends Effect

@export var damage_amount: int = 5
@export var dice_scene: PackedScene


func play(effect_variables: Dictionary) -> Dictionary:
	# If there's no target, destroy the die
	if len(effect_variables['targets']) == 0:
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
		dice_to_send[i].send_to_target(effect_variables['actor'], effect_variables['targets'][i], damage)
	
	return effect_variables
	

func damage(actor: Actor, target: Actor, die_used: Dice) -> void:
	# The target might die before this is called,
	# so add the die back to the sender's queue if needed
	if not target:
		# Check that we can return it to the sender.
		# If we can't, just destroy the die
		# This potentially should add it back to the player's queue. We'll see.
		if not actor:
			die_used.destroy()
			return
			
		actor.add_die_to_queue(die_used)
		return
	
	# Also, we need to add the die to the target then damage it.
	# If the target dies to this attack without owning the die, 
	# it won't handle returning the die to the player's queue
	target.add_die_to_queue(die_used)
	target.take_damage(damage_amount)
