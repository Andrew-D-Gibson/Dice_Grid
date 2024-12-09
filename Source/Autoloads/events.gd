extends Node

# Dice signals
signal spawn_dice(amount_to_spawn: int)
signal die_destroyed(die: Dice)


# Player signals
signal change_player_health(amount: int) # Negative amount damages, positive heals
signal damage_player(amount: int)
