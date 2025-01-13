@tool
class_name Cell
extends Node2D

@export var hovered := false

@export var grid_location: Vector2i

var occupying_tile: Tile
var modifiers: Array[CellModifier] = []
var locked_out: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_graphics()


func update_graphics() -> void:
	$AnimatedSprite2D.frame = 1 if hovered else 0


func _on_area_2d_mouse_entered() -> void:
	hovered = true
	Globals.hovered_cell = self
	update_graphics()


func _on_area_2d_mouse_exited() -> void:
	hovered = false
	
	if Globals.hovered_cell == self:
		Globals.hovered_cell = null
	
	update_graphics()


func on_die_dropped(die: Dice) -> void:
	# Handle cell modifiers, including lockout
	for mod in modifiers:
		if mod is LockoutModifier and mod.activation_node.criteria_satisfied(die):
			Globals.player.remove_die_from_queue(die)
			
			# Set up the effects dictionary for chaining effects
			var effect_dict = {
				'actor': Globals.player,
				'targets': null,
				'die_used': die,
				'activating_node': self
			}
			for effect in mod.get_children():
				if effect is Effect:
					effect_dict = effect.play(effect_dict)
				
			locked_out = false
			if occupying_tile:
				occupying_tile.can_be_held = true
			modifiers.erase(mod)
			mod.queue_free()
			return
	
	# Fail the drop if we're locked out
	if locked_out:
		return
		
	# Fail the drop if we're not over a tile
	if not occupying_tile:
		return
		
	# Try to activate our tile using the die
	# If it fails the die will return to its previous location
	occupying_tile.check_activation(die)


func add_modifier(mod: CellModifier) -> void:
	# Check that we're only ever adding a single lockout
	if mod is LockoutModifier:
		if locked_out:
			mod.queue_free()
			return
		else:
			locked_out = true
			if occupying_tile:
				occupying_tile.can_be_held = false
				occupying_tile.highlight.visible = false
	
	mod.global_position = global_position
	modifiers.append(mod)
