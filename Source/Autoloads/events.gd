extends Node

# Dice signals
signal spawn_dice(amount_to_spawn: int)
signal remove_die_from_queue(die: Dice)
signal add_die_to_queue(die: Dice)


# Player signals
signal change_player_health(amount: int) # Negative amount damages, positive heals
signal change_player_defense(amount: int)
signal damage_player(amount: int)


# Tile signals
signal tile_clicked_for_info(tile: Tile)


# Game Control signals
signal game_over()
