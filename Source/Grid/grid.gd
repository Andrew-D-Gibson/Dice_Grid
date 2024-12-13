@tool
extends Node2D

@export var grid_save_state: Grid_State

@export var grid_width := 5
@export var grid_height := 5
@export var grid_spacing := 32
@export var grid_position_offset := Vector2(-198, -64)

@onready var cell_scene := preload("res://Source/Grid/cell.tscn")


func _ready() -> void:
	for x in range(grid_width):
		for y in range(grid_height):
			var cell = cell_scene.instantiate()
			cell.position = Vector2(x * grid_spacing, y * grid_spacing) + grid_position_offset
			cell.grid_location = Vector2i(x, y)
			add_child(cell)
			
			# Add tiles from our save state
			if grid_save_state != null and grid_save_state.tile_locations.has(Vector2i(x,y)):
				var tile = grid_save_state.tile_locations[Vector2i(x,y)].instantiate()
				tile.attach_to_cell(cell)
				tile.position = cell.position
				add_child(tile)
				
			
			
