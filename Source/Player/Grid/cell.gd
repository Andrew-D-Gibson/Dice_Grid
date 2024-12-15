@tool
class_name Cell
extends Node2D

@export var hovered := false

@onready var empty_texture := preload("res://Assets/Grid/empty_cell.png")
@onready var hovered_texture := preload("res://Assets/Grid/empty_cell_hovered.png")

@export var grid_location: Vector2i

var occupying_tile: Tile

func _ready():
	update_graphics()


func update_graphics() -> void:
	$Sprite2D.texture = hovered_texture if hovered else empty_texture


func _on_area_2d_mouse_entered() -> void:
	hovered = true
	Globals.hovered_cell = self
	update_graphics()


func _on_area_2d_mouse_exited() -> void:
	hovered = false
	
	if Globals.hovered_cell == self:
		Globals.hovered_cell = null
	
	update_graphics()
