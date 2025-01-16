class_name EngineCharger
extends Area2D

@export var max_charge: int = 20
var current_charge: int = 0

@export var activation_node: Activation

@export_multiline var activation_text: String
@export_multiline var description_text: String

var time_since_mouse_pressed: float 


func _ready() -> void:
	_update_ui()
	
	
func _process(delta: float) -> void:
	time_since_mouse_pressed += delta


func _on_area_2d_mouse_entered() -> void:
	Globals.hovered_engine_charger = self


func _on_area_2d_mouse_exited() -> void:
	if Globals.hovered_engine_charger == self:
		Globals.hovered_engine_charger = null
		
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check for the left mouse pressed event
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			time_since_mouse_pressed = 0
		else:
			if time_since_mouse_pressed < 0.4:
				Events.show_info.emit(activation_text, $Sprite2D.texture, description_text)
	

func on_die_dropped(die: Dice) -> void:
	if activation_node.criteria_satisfied(die) and current_charge < max_charge:
		Globals.player.remove_die_from_queue(die)
		
		# Set up the effects dictionary for chaining effects
		var effect_dict = {
			'actor': Globals.player,
			'targets': null,
			'die_used': die,
			'activating_node': self
		}
		
		for effect in $"Effects Parent".get_children(false):
			if effect is Effect:
				effect_dict = effect.play(effect_dict)
				
		bob_tween()


func change_charge(amount: int) -> void:
	print(amount)
	current_charge += amount
	current_charge = clampi(current_charge, 0, max_charge)
	
	_update_ui()


func _update_ui() -> void:
	$ProgressBar.value = float(current_charge) / float(max_charge)
	
	
func bob_tween() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, 'position', $Sprite2D.position - Vector2(0, 8), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Sprite2D, 'position', $Sprite2D.position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
