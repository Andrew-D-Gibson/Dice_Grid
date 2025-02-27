class_name Dice
extends Holdable

@export var value: int = 0
var locked_out_full_time: float = 0
var locked_out_time_remaining: float = 0

var destroy_particles := preload('res://Source/Dice/destroy_particles.tscn')

func _ready() -> void:
	super()
	if value == 0:
		randomize_value()
	$AnimatedSprite2D.frame = value
	

func _process(delta: float) -> void:
	super(delta)
	
	if locked_out_time_remaining > 0:
		can_be_held = false
		locked_out_time_remaining -= delta
		$TextureProgressBar.value = locked_out_time_remaining / locked_out_full_time
	else:
		can_be_held = true
		
	if being_held:
		var current_dice_queue_position = Globals.player.dice_queue.find(self)
		
		if global_position.x > -156 and global_position.x < 156 and global_position.y < 172 and global_position.y > 148:
				var hovered_dice_queue_position = int((global_position.x + 156) / 32.0)
				hovered_dice_queue_position = min(hovered_dice_queue_position, len(Globals.player.dice_queue)-1)
				
				if current_dice_queue_position != hovered_dice_queue_position:
					Globals.player.dice_queue.remove_at(current_dice_queue_position)
					Globals.player.dice_queue.insert(hovered_dice_queue_position, self)
					Globals.player._update_dice_queue_locations()
					
		elif current_dice_queue_position != len(Globals.player.dice_queue)-1:
			Globals.player.dice_queue.remove_at(current_dice_queue_position)
			Globals.player.add_die_to_queue(self, true, false)
				

func set_lockout_time(duration: float) -> void:
	locked_out_full_time = duration
	locked_out_time_remaining = duration


func randomize_value() -> void:
	set_value(randi_range(1,6))
	
	
func set_value(val: int) -> void:
	value = val
	$AnimatedSprite2D.frame = value


func _drop() -> void:
	_check_valid_drop()
	super()


func _check_valid_drop():
	# Pass this die onto the cell or engine charger to handle as needed
	if Globals.hovered_cell:
		Globals.hovered_cell.on_die_dropped(self)
	elif Globals.hovered_engine_charger:
		Globals.hovered_engine_charger.on_die_dropped(self)
		

func destroy():
	var particles = destroy_particles.instantiate()
	particles.position = global_position
	add_sibling(particles)
	particles.emitting = true
	
	queue_free()


func attack_tween(target: Actor, damage_amount: int) -> void:
	var tween_time = 0.6
	being_tweened = true
	can_be_held = false
	
	# For some reason, with the 'being_tweened' _process workaround
	# there's a single frame that's processed that moves the die.
	# This line makes that single frame not move the die before being tweened.
	last_valid_position = position
	
	var target_location: Vector2 = target.global_position if target is not Player else target.damage_location
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, 'global_position', target_location, tween_time).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
	tween.tween_property(self, 'rotation_degrees', 360 * 6, tween_time).from(0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	var finish_send = func finish_send() -> void:
		being_tweened = false
		if target:
			target.add_die_to_queue(self)
			target.take_damage(damage_amount)
		else:
			Globals.player.add_die_to_queue(self)
	
	tween.chain().tween_callback(finish_send)
	

func send_tween(target: Actor) -> void:
	var tween_time = 0.75
	being_tweened = true
	can_be_held = false
	
	# For some reason, with the 'being_tweened' _process workaround
	# there's a single frame that's processed that moves the die.
	# This line makes that single frame not move the die before being tweened.
	last_valid_position = position
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, 'global_position', target.global_position, tween_time).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($AnimatedSprite2D, 'scale', Vector2(0.1,0.1), tween_time).from_current().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	var finish_send = func finish_send() -> void:
		being_tweened = false
		$AnimatedSprite2D.scale = Vector2(1,1)
		
		if target:
			target.add_die_to_queue(self)
		else:
			Globals.player.add_die_to_queue(self)
		
	
	tween.chain().tween_callback(finish_send)


func activate_tile_tween(target: Tile) -> void:
	var tween_time = 0.75
	being_tweened = true
	can_be_held = false
	 
	# For some reason, with the 'being_tweened' _process workaround
	# there's a single frame that's processed that moves the die.
	# This line makes that single frame not move the die before being tweened.
	last_valid_position = position
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, 'global_position', target.global_position, tween_time).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property($AnimatedSprite2D, 'scale', Vector2(0.1,0.1), tween_time).from_current().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	var finish_send = func finish_send() -> void:
		being_tweened = false
		$AnimatedSprite2D.scale = Vector2(1,1)
		
		if target:
			target.check_activation(self)
		else:
			Globals.player.add_die_to_queue(self)
		
	tween.chain().tween_callback(finish_send)


func reroll_tween(enemy_to_act: Enemy = null) -> void:
	var tween_time = 0.75
	can_be_held = false

	var tween = get_tree().create_tween()
	tween.tween_property(self, 'rotation_degrees', 180, tween_time/2).from(0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(randomize_value)
	tween.tween_property(self, 'rotation_degrees', 360, tween_time/2).from(180).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	var finish_reroll = func finish_reroll() -> void:
		can_be_held = true
		small_shake()
		
		await get_tree().create_timer(1).timeout
		if enemy_to_act != null:
			enemy_intent_tween(enemy_to_act)
			
	
	tween.tween_callback(finish_reroll)


func enemy_intent_tween(enemy_to_act: Enemy) -> void:
	var tween_time = 0.75
	being_tweened = true
	can_be_held = false
	
	# For some reason, with the 'being_tweened' _process workaround
	# there's a single frame that's processed that moves the die.
	# This line makes that single frame not move the die before being tweened.
	last_valid_position = position
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, 'global_position', enemy_to_act.action_indicator.get_child(value-1).global_position, tween_time).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($AnimatedSprite2D, 'scale', Vector2(0.1,0.1), tween_time).from_current().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	var finish_send = func finish_send() -> void:
		being_tweened = false
		$AnimatedSprite2D.scale = Vector2(1,1)
		
		if enemy_to_act:
			enemy_to_act.act(self)

	tween.chain().tween_callback(finish_send)
