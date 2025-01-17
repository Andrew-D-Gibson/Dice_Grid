extends Control

func _ready() -> void:
	Events.jump_started.connect(fade_in_and_out)
	
	$ColorRect.color = Color($ColorRect.color, 1)
	fade_out()
	
	
func fade_out() -> void:
	var tween_time = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, 'color', Color($ColorRect.color, 0), tween_time/2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	
func fade_in_and_out() -> void:
	var tween_time = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, 'color', Color($ColorRect.color, 1), tween_time/2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Events.make_jump_transition.emit)
	tween.tween_property($ColorRect, 'color', Color($ColorRect.color, 0), tween_time/2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
