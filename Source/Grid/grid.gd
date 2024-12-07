@tool
extends Node2D

@export var grid_width := 5
@export var grid_height := 5
@export var grid_spacing := 32

@onready var cell_scene := preload("res://Source/Grid/cell.tscn")


func _ready() -> void:
	for x in range(grid_width):
		for y in range(grid_height):
			var cell = cell_scene.instantiate()
			cell.position = Vector2(x * grid_spacing, y * grid_spacing)
			cell.grid_location = Vector2i(x, y)
			add_child(cell)
			
	# Move this parent node to center the grid on 0,0
	global_position = Vector2(
		-((grid_width - 1) * grid_spacing)/2.0, 
		-((grid_height - 1) * grid_spacing)/2.0)
