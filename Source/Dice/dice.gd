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
	# Fail the drop if we're not over a cell
	if not Globals.hovered_cell:
		return
		
	# Fail the drop if we're not over a tile
	if not Globals.hovered_cell.occupying_tile:
		return
		
	# Try to activate using the dice
	# If it fails the dice will return to its previous location
	# If it succeeds the dice will be destroyed
	Globals.hovered_cell.occupying_tile.check_activation(self)
		

func destroy():
	var particles = destroy_particles.instantiate()
	particles.position = global_position
	add_sibling(particles)
	particles.emitting = true
	
	queue_free()


func attack_tween(actor: Actor, target: Actor, effect_function) -> void:
	var tween_time = 0.75
	being_tweened = true
	can_be_held = false
	
	# For some reason, with the 'being_tweened' _process workaround
	# there's a single frame that's processed that moves the die.
	# This line makes that single frame not move the die before being tweened.
	last_valid_position = position
	
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, 'global_position', target.global_position, tween_time).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN)
	tween.tween_property(self, 'rotation_degrees', 360 * 6, tween_time).from(0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	var finish_send = func finish_send() -> void:
		being_tweened = false
		effect_function.call(actor, target, self)
	
	tween.chain().tween_callback(finish_send)
	

func send_tween(actor: Actor, target: Actor, effect_function) -> void:
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
		effect_function.call(actor, target, self)
	
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
		
		target.check_activation(self, true)
	
	tween.chain().tween_callback(finish_send)
