extends Enemy_Action

@export var def_amount: int = 3

func act(acting_enemy: Enemy) -> void:
	acting_enemy.change_defense(def_amount)
