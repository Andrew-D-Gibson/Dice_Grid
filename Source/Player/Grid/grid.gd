@tool
class_name Grid
extends Node2D

@export var grid_width := 5
@export var grid_height := 5
@export var grid_spacing := 32

@export var cell_scene: PackedScene

# The 2D array of cells
# GDScript doesn't support 2D array declaration to my knowledge
var cell_array

func create_and_populate_grid(tile_dictionary: Dictionary[Vector2, PackedScene]) -> void:
	cell_array = []
	
	var grid_pos_offset := Vector2(-((grid_width-1) * grid_spacing)/2.0, -((grid_height-1) * grid_spacing)/2.0)
	for x in range(grid_width):
		cell_array.append([])
		
		for y in range(grid_height):
			var cell = cell_scene.instantiate()
			cell.position = grid_pos_offset + Vector2(x * grid_spacing, y * grid_spacing)
			cell.grid_location = Vector2i(x, y)
			add_child(cell)
			
			cell_array[x].append(cell)
			
	for pos in tile_dictionary:
		var tile = tile_dictionary[pos].instantiate()
		tile.attach_to_cell(cell_array[int(pos.x)][int(pos.y)])
		tile.global_position = cell_array[pos.x][pos.y].global_position
		add_child(tile)
