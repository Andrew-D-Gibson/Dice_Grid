class_name TargetingComputer
extends Node2D

@export var targeting_indicator_offset: Vector2 = Vector2(38, 28)
var targeted_enemy_index: int

func _ready() -> void:
	Events.enemy_died.connect(_check_target_is_valid)
	attempt_retarget()
	

func attempt_retarget() -> void:
	targeted_enemy_index = 0
	_check_target_is_valid()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('target_left'):
		targeted_enemy_index -= 1
		_check_target_is_valid()

		
	if event.is_action_pressed('target_right'):
		targeted_enemy_index += 1
		_check_target_is_valid()
		

func _on_left_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check for the left mouse pressed event
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		targeted_enemy_index -= 1
		_check_target_is_valid()


func _on_right_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check for the left mouse pressed event
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		targeted_enemy_index += 1
		_check_target_is_valid()


func _check_target_is_valid() -> void:
	var enemies = get_tree().get_nodes_in_group('enemies')
	
	# Remove any dead enemies from our list
	# Enemies signal their own death, and so aren't removed from the tree in time
	for i in range(len(enemies)-1, -1, -1):
		if enemies[i].hp_and_def.health == 0:
			enemies.remove_at(i)
	
	# Check that there even are enemies to target
	if len(enemies) == 0:
		Globals.targeted_enemy = null
		targeted_enemy_index = -1
	
	# Check if we need to wrap around to the last enemy
	elif targeted_enemy_index <= -1:
		targeted_enemy_index = len(enemies) - 1
		Globals.targeted_enemy = enemies[targeted_enemy_index]
		
	# Check if we need to wrap around to the first enemy
	elif targeted_enemy_index >= len(enemies):
		targeted_enemy_index = 0
		Globals.targeted_enemy = enemies[targeted_enemy_index]
		
	# Given that there are enemies and we're within a valid range, target is valid
	else:
		Globals.targeted_enemy = enemies[targeted_enemy_index]

	_update_ui()
	
	
func _update_ui() -> void:
	if !Globals.targeted_enemy:
		$"Targeting Indicator".visible = false
		$"Target Image".texture = null
		$Screen.stop()
		$Screen.frame = 6
	else:
		$Screen.stop()
		$Screen.play('static')
		# Set up the image on the computer
		if Globals.targeted_enemy.targeting_computer_image:
			$"Target Image".texture = Globals.targeted_enemy.targeting_computer_image
			
		# Move the targeting indicator
		$"Targeting Indicator".visible = true
		
		var tween_time = 0.3
		var tween = get_tree().create_tween()
		tween.tween_property($"Targeting Indicator", 'global_position', Globals.targeted_enemy.global_position + targeting_indicator_offset, tween_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		#$"Targeting Indicator".global_position = Globals.targeted_enemy.global_position + targeting_indicator_offset
		
		tween.tween_callback(bob)

func bob() -> void:
	if !Globals.targeted_enemy:
		return
		
	var bob_time = 1.5
	var bob_tween = get_tree().create_tween()
	bob_tween.tween_property($"Targeting Indicator", 'global_position', Globals.targeted_enemy.global_position + targeting_indicator_offset + Vector2(8, 8), bob_time/2.0).from(Globals.targeted_enemy.global_position + targeting_indicator_offset).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob_tween.tween_property($"Targeting Indicator", 'global_position', Globals.targeted_enemy.global_position + targeting_indicator_offset, bob_time/2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob_tween.set_loops()
