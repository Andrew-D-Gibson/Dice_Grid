@tool
extends Node2D

@export var occupied := false
@export var hovered := false

@onready var empty_texture := preload("res://Assets/Grid/empty_cell.png")
@onready var hovered_texture := preload("res://Assets/Grid/empty_cell_hovered.png")

@export var grid_location: Vector2i


func _ready():
	_update_graphics()


func _update_graphics() -> void:
	if not occupied:
		$Sprite2D.texture = hovered_texture if hovered else empty_texture
		return
		

func _on_area_2d_mouse_entered() -> void:
	hovered = true
	_update_graphics()


func _on_area_2d_mouse_exited() -> void:
	hovered = false
	_update_graphics()
