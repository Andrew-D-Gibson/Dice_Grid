extends Effect

@export var damage_amount: int = 5


func play(die: Dice = null) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	# The list could be empty, 
	# so stop if there's not a potential enemy to hit
	if len(enemies) == 0:
		die.destroy()
		return
	
	var random_enemy = enemies.pick_random()
	Events.remove_die_from_queue.emit(die)
	die.send_to_entity(random_enemy, damage_enemy)
	
	
func damage_enemy(enemy: Enemy, die_used: Dice) -> void:
	# The enemy might die before this is called,
	# so add the die back to the queue if so
	if not enemy:
		Events.add_die_to_queue.emit(die_used)
		return
	
	# Also, we need to add the die to the enemy then damage it.
	# If the enemy dies to this attack without owning the die, 
	# it won't handle returning the die to the queue
	enemy.add_die_to_queue(die_used)
	enemy.take_damage(damage_amount)
	
