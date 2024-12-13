extends Node2D

@export_category("Encounter")
@export var encounter: Encounter

@export_category("Components")
@export var enemy_manager: Enemy_Manager


func _ready() -> void:
	$Background.texture = encounter.background
	
	if enemy_manager != null:
		enemy_manager.spawn_enemies(encounter.enemies)
