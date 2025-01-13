@tool
extends Node2D

@export var num_of_indicators: int = 3
@export var indicator_sprite_sheet: SpriteFrames

@export var num_of_uses: int = num_of_indicators
var indicator_displays: Array[AnimatedSprite2D] = []

func _ready() -> void:
	update_num_of_indicators(num_of_indicators)
	$Button.set_focus_mode(0)
	
	
func update_num_of_indicators(indicators: int, uses: int = -1) -> void:
	# Set internal values
	num_of_indicators = indicators
	if uses == -1:
		num_of_uses = num_of_indicators
	else:
		num_of_uses = uses
	
	# Clear out any old indicators
	for child in indicator_displays:
		child.queue_free()
	indicator_displays = []
	
	# Create new indicators
	var spacing = -10
	for i in range(num_of_indicators):
		var indicator = AnimatedSprite2D.new()
		indicator.sprite_frames = indicator_sprite_sheet
		indicator.frame = 1
		
		var offset = (i - (num_of_indicators - 1) / 2.0) * spacing
		indicator.position = Vector2(offset, -13)
		
		indicator_displays.append(indicator)
		add_child(indicator)
		
	_update_ui()


func _reroll() -> void:
	if num_of_uses <= 0:
		return
		
	$AnimatedSprite2D.play('button_pushed')
	
	for dice in Globals.player.dice_queue:
		dice.reroll_tween()
	num_of_uses -= 1
	_update_ui()


func _update_ui() -> void:
	# Update the indicator display sprites
	for i in range(len(indicator_displays)):
		if num_of_uses > i:
			indicator_displays[i].frame = 1
		else:
			indicator_displays[i].frame = 0


func refresh_rerolls() -> void:
	num_of_uses = num_of_indicators
	$Button.disabled = false
	$AnimatedSprite2D.set_animation('button_pushed')
	$AnimatedSprite2D.frame = 0


func _on_animated_sprite_2d_animation_finished() -> void:
	if num_of_uses <= 0:
		$Button.disabled = true
		$AnimatedSprite2D.play('disabled')
