extends Effect

@export var tile_sprite: Sprite2D
@export var shake_strength: float = 2.0
@export var shake_duration: float = 0.2

var current_shake_strength: float = 0

func play(dice_value: int = 0) -> void:
	current_shake_strength = shake_strength
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "current_shake_strength", 0, shake_duration)
	
	
func _process(delta: float) -> void:
	if current_shake_strength > 0:
		tile_sprite.position = _random_offset()


func _random_offset() -> Vector2:
	return Vector2(
		randf_range(-current_shake_strength, current_shake_strength),
		randf_range(-current_shake_strength, current_shake_strength)
	)
