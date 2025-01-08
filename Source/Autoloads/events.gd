extends Node


# Tile signals
signal tile_clicked_for_info(tile: Tile)


# UI Control signals
signal game_over()
signal game_pause_toggled()
signal dev_console_toggled()


# Game state signals
signal load_game_state(encounter_num: int)
