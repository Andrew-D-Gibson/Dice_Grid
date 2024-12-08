extends Effect

func play(dice_value: int = 0) -> void:
	$CPUParticles2D.emitting = true


func _on_cpu_particles_2d_finished() -> void:
	self.queue_free()
