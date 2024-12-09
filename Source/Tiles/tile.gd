class_name Tile
extends Holdable

var host_cell: Cell

@export var activation_node: Activation
@export var effects_parent: Effects_Parent


func check_activation(dice: Dice = null) -> void:
	if activation_node.criteria_satisfied(dice):
		var dice_value = dice.value
		dice.destroy()
		
		effects_parent.play(dice_value)


func _drop() -> void:
	_check_valid_drop()
	super()


func _check_valid_drop():
	# Fail the drop if we're not over a cell
	if not Globals.hovered_cell:
		return
		
	# Fail the drop if we're not over an empty cell
	if Globals.hovered_cell.occupying_tile:
		return
		
	# We're over an empty cell, so succeed the drop!
	# Remove this tile from the previous host cell if needed
	if host_cell:
		host_cell.occupying_tile = null
		
	# Give this tile to the new host cell
	host_cell = Globals.hovered_cell
	host_cell.occupying_tile = self
	
	last_valid_position = host_cell.global_position
