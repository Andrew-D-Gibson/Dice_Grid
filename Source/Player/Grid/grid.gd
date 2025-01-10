class_name Grid
extends Node2D

@export var cell_scene: PackedScene

# The 2D array of cells, stored as a dictionary so
# we can check if things exist without running the risk of an error
var cell_array = {}

func create_and_populate_grid(tile_dictionary: Dictionary[Vector2i, PackedScene]) -> void:
	var cell = cell_scene.instantiate()
	cell.position = Vector2(0, 0)
	cell.grid_location = Vector2i(0, 0)
	add_child(cell)
	
	cell_array[0] = {}
	cell_array[0][0] = cell
			
	for pos in tile_dictionary:
		var tile = tile_dictionary[pos].instantiate()
		
		if cell_array.has(pos.x) and cell_array[pos.x].has(pos.y):
			tile.attach_to_cell(cell_array[pos.x][pos.y])
			tile.global_position = cell_array[pos.x][pos.y].global_position
			add_child(tile)


func get_surrounding_tiles_by_pip_value(value: int, activator_grid_location: Vector2i) -> Array[Tile]:
	var pip_offsets = {
		2: [Vector2i(-1,-1), Vector2i(1,1)],
		3: [Vector2i(-1,1), Vector2i(1,-1)],
		4: [Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(1,1)],
		5: [Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1), Vector2i(1,1)],
		6: [Vector2i(-1,-1), Vector2i(-1,0), Vector2i(-1,1), 
			Vector2i(1,-1), Vector2i(1,0), Vector2i(1,1)]
	}
	
	if not pip_offsets.has(value):
		return []
	
	var tile_list: Array[Tile] = []
	for offset in pip_offsets[value]:
		# Check for valid x coordinate
		if not cell_array.has(activator_grid_location.x + offset.x):
			continue
		
		# Check for valid y coordinate
		if not cell_array[activator_grid_location.x + offset.x].has(activator_grid_location.y + offset.y):
			continue
			
		# Check for lockout
		if cell_array[activator_grid_location.x + offset.x][activator_grid_location.y + offset.y].locked_out:
			continue
			
		# Check for a tile to activate
		if not cell_array[activator_grid_location.x + offset.x][activator_grid_location.y + offset.y].occupying_tile:
			continue

		# Finally add the tile to the approved list
		tile_list.append(cell_array[activator_grid_location.x + offset.x][activator_grid_location.y + offset.y].occupying_tile)
		
	return tile_list
