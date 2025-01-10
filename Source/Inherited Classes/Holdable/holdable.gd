class_name Holdable
extends Area2D

var can_be_held: bool = true
var being_held: bool = false

var being_tweened = false

@export var follow_strength: float = 25
var last_valid_position: Vector2
var desired_position: Vector2

var shake_strength: float = 0
@export var shake_fade: float = 5
@export var small_shake_amount: float = 1
@export var large_shake_amount: float = 2


func _ready() -> void:
	if not last_valid_position:
		last_valid_position = global_position
		
	desired_position = last_valid_position


func _process(delta: float) -> void:
	if being_tweened:
		return
		
	if being_held:
		desired_position = get_global_mouse_position()
		
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_drop()
			
	global_position = global_position.lerp(desired_position, follow_strength * delta)
	
	# Shaking
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		global_position += _random_offset()
		
		
func _random_offset() -> Vector2:
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
	
func small_shake() -> void:
	shake_strength = small_shake_amount
	
	
func large_shake() -> void:
	shake_strength = large_shake_amount
	
	
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Don't get picked up if we can't be held
	if not can_be_held:
		return
		
	# Don't get picked up if the mouse is already holding an object
	if Globals.held_object:
		return
	
	# Check for the left mouse pressed event
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		_pickup()


func _pickup() -> void:
	last_valid_position = global_position
	
	being_held = true
	z_index += 1
	Globals.held_object = self
	

func _drop() -> void:
	desired_position = last_valid_position
	being_held = false
	z_index -= 1
	Globals.held_object = null
	
	
func set_home_location(location: Vector2) -> void:
	last_valid_position = location
	desired_position = location


func bob_tween() -> void:
	being_tweened = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'global_position', global_position - Vector2(0, 8), 0.1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	#tween.tween_property(self, 'global_position', global_position, 0.25).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	
	var disable_tween = func disable_tween() -> void:
		being_tweened = false
	
	tween.tween_callback(disable_tween)
