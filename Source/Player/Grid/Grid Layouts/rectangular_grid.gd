extends Grid

@export var grid_width := 5
@export var grid_height := 5
@export var grid_spacing := 32


func create_and_populate_grid(tile_dictionary: Dictionary[Vector2i, PackedScene]) -> void:
	cell_array = {}
	
	var grid_pos_offset := Vector2(-((grid_width-1) * grid_spacing)/2.0, -((grid_height-1) * grid_spacing)/2.0)
	for x in range(grid_width):
		cell_array[x] = {}
		
		for y in range(grid_height):
			var cell = cell_scene.instantiate()
			cell.position = grid_pos_offset + Vector2(x * grid_spacing, y * grid_spacing)
			cell.grid_location = Vector2i(x, y)
			add_child(cell)
			
			cell_array[x][y] = cell
			
	for pos in tile_dictionary:
		var tile = tile_dictionary[pos].instantiate()
		
		if cell_array.has(pos.x) and cell_array[pos.x].has(pos.y):
			tile.attach_to_cell(cell_array[pos.x][pos.y])
			tile.global_position = cell_array[pos.x][pos.y].global_position
			add_child(tile)
