extends Effect

func play(die: Dice = null) -> void:
	Events.remove_die_from_queue.emit(die)
	Events.add_die_to_queue.emit(die)
