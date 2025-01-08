class_name GameState
extends Resource

@export_category('Player Info')
@export var player_health: int
@export var player_max_health: int
@export var player_defense: int

@export_category('Player Dice')
@export var num_of_dice: int

@export_category('Player Grid and Tiles')
@export var grid: PackedScene
@export var grid_width: int
@export var grid_height: int
@export var tile_locations: Dictionary[Vector2i, PackedScene]

@export_category('Current Encounter')
@export var encounter: Encounter
