extends Effect

func play(effect_variables: Dictionary) -> Dictionary:
	# If we don't have a target, give the dice to the player
	if len(effect_variables['targets']) == 0:
		Globals.player.add_die_to_queue(effect_variables['die_used'])
	else:
		effect_variables['die_used'].send_tween(effect_variables['actor'], effect_variables['targets'][0], give_to_target)
	
	return effect_variables
	

func give_to_target(actor: Actor, target: Actor, die_used: Dice) -> void:
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
	
	target.add_die_to_queue(die_used)
