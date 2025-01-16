extends Node


# Tile signals
signal tile_clicked_for_info(tile: Tile)


# UI Control signals
signal game_over()
signal game_pause_toggled()
signal dev_console_toggled()
signal show_info(top_label_text: String, texture: Texture2D, bottom_label_text: String)


# Game state signals
signal load_game_state(encounter_num: int)

signal enemy_died()
