class_name Holdable
extends Area2D

var being_held: bool = false
@onready var last_valid_position: Vector2 = position

@export var follow_strength: float = 25
var desired_position: Vector2


func _ready() -> void:
	desired_position = last_valid_position


func _process(delta: float) -> void:
	if being_held:
		desired_position = get_global_mouse_position()
		
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_drop()
			
	position = position.lerp(desired_position, follow_strength * delta)
		
	
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Don't get picked up if the mouse is already holding an object
	if Globals.held_object:
		return
	
	# Check for the left mouse pressed event
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		_pickup()


func _pickup() -> void:
	last_valid_position = position
	
	being_held = true
	Globals.held_object = self
	

func _drop() -> void:
	desired_position = last_valid_position
	being_held = false
	Globals.held_object = null
