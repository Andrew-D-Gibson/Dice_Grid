extends Effect

@export var damage_amount: int = -1000
@export var dice_scene: PackedScene

func _ready() -> void:
	if get_parent() is EnemyAction and get_parent().amount != -1:
		damage_amount = get_parent().amount


func play(effect_variables: Dictionary) -> Dictionary:
	# First remove null entries from our list of targets (they may have died)
	for i in range(len(effect_variables['targets'])-1, -1, -1):
		if not effect_variables['targets'][i]:
			effect_variables['targets'].remove_at(i)
			
	# If there's no target, return the die to the player
	if len(effect_variables['targets']) == 0:
		Globals.player.add_die_to_queue(effect_variables['die_used'], true)
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
		if damage_amount == -1000:
			dice_to_send[i].attack_tween(effect_variables['targets'][i], dice_to_send[i].value)
		else:
			dice_to_send[i].attack_tween(effect_variables['targets'][i], damage_amount)
			
	return effect_variables
