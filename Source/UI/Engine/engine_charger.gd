class_name EngineCharger
extends Area2D

@export var max_charge: int = 20
var current_charge: int = 0

@export var activation_node: Activation

@export_multiline var activation_text: String
@export_multiline var description_text: String

var time_since_mouse_pressed: float 


func _ready() -> void:
	Events.enemy_died.connect(_check_for_enemies_to_full_charge)
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
	# Update the value of the progress bar
	var tween_time = 0.25
	var tween = get_tree().create_tween()
	tween.tween_property($ProgressBar, 'value', float(current_charge) / float(max_charge), tween_time).from_current().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# Update the jump button's label
	if current_charge < max_charge:
		$"Jump Button/RichTextLabel".text = 'JUMP'
		$"Jump Button/RichTextLabel".add_theme_color_override("default_color", '#63605c')
	else:
		$"Jump Button/RichTextLabel".text = '[wave amp=50.0 freq=5.0 connected=1]JUMP[/wave]'
		$"Jump Button/RichTextLabel".add_theme_color_override("default_color", '#eed35d')
		
		
	
func bob_tween() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, 'position', $Sprite2D.position - Vector2(0, 8), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Sprite2D, 'position', $Sprite2D.position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_jump_button_pushed() -> void:
	if current_charge >= max_charge:
		Events.jump_started.emit()


func _check_for_enemies_to_full_charge() -> void:
	var enemies = get_tree().get_nodes_in_group('enemies')
	
	# Remove any dead enemies from our list
	# Enemies signal their own death, and so aren't removed from the tree in time
	for i in range(len(enemies)-1, -1, -1):
		if enemies[i].hp_and_def.health == 0:
			enemies.remove_at(i)
	
	# Check that there even are enemies to target
	if len(enemies) == 0:
		current_charge = max_charge
		_update_ui()


func reset_charge() -> void:
	current_charge = 0
	_update_ui()
