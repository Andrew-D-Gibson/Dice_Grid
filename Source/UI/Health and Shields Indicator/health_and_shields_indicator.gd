class_name HPShieldsIndicator
extends Node2D

var need_to_update_health_white: bool = false
var time_since_health_change: float = 0

var health_label_shake_time: float = 0


func _ready() -> void:
	set_shields()
	set_health()
	
	
func _process(delta: float) -> void:
	if need_to_update_health_white:
		if time_since_health_change > 0.75:
			var tween_time = 0.5
			var tween = get_tree().create_tween()
			tween.tween_property($"Health Update Bar", 'value', float(Globals.player.hp_and_def.health) / float(Globals.player.hp_and_def.max_health), tween_time).from_current().set_trans(Tween.TRANS_QUAD)
			
			need_to_update_health_white = false
		else:
			time_since_health_change += delta
			
	if health_label_shake_time > 0:
		$"Health Label".text = '[shake rate=75, level=12]HULL\n'\
		+ str(Globals.player.hp_and_def.health) + '/' + str(Globals.player.hp_and_def.max_health)\
		+ '[/shake]'
		health_label_shake_time -= delta
	else:
		$"Health Label".text = 'HULL\n' + str(Globals.player.hp_and_def.health) + '/' + str(Globals.player.hp_and_def.max_health)


func set_shields() -> void:		
	$"Shields Label".text = str(Globals.player.hp_and_def.defense)
	
	if Globals.player.hp_and_def.defense <= 0:
		$Shields.visible = false
		return
	
	$Shields.visible = true
	if Globals.player.hp_and_def.defense < Globals.player.hp_and_def.max_health / 2.0:
		$Shields.frame = 2
	elif Globals.player.hp_and_def.defense < Globals.player.hp_and_def.max_health:
		$Shields.frame = 1
	else:
		$Shields.frame = 0


func set_health() -> void:
	if $"Health Bar".value > float(Globals.player.hp_and_def.health) / float(Globals.player.hp_and_def.max_health):
		health_label_shake_time = 0.25
		
	var tween_time = 0.1
	var tween = get_tree().create_tween()
	tween.tween_property($"Health Bar", 'value', float(Globals.player.hp_and_def.health) / float(Globals.player.hp_and_def.max_health), tween_time).from_current().set_trans(Tween.TRANS_QUAD)
	
	need_to_update_health_white = true
	time_since_health_change = 0
	
	#$"Health Bar".value = float(Globals.player.hp_and_def.health) / float(Globals.player.hp_and_def.max_health)
	$"Health Label".text = 'HULL\n' + str(Globals.player.hp_and_def.health) + '/' + str(Globals.player.hp_and_def.max_health)
