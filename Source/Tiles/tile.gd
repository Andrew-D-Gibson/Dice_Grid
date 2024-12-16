class_name Tile
extends Holdable

var host_cell: Cell

@export_category('Tile Functionality')
@export var activation_node: Activation

@export_category('Description')
@export var description: String


# Set the time (in seconds) that can elapse for a "click" to be registered,
# rather than a long "hold."  A "click" means we want to show this tile's info.
var click_window_time: float = 0.4

# Record this tile's texture so we can display it's info in the UI later
@onready var tile_texture: Texture2D = $Sprite2D.texture


func check_activation(die: Dice = null) -> void:
	if activation_node.criteria_satisfied(die):
		Globals.player.remove_die_from_queue(die)
		
		# Set up the effects dictionary for chaining effects
		var effect_dict = {
			'actor': Globals.player,
			'targets': null,
			'die_used': die,
			'activating_node': self
		}
		
		for effect in $"Effects Parent".get_children(false):
			if effect is Effect:
				effect_dict = effect.play(effect_dict)


func _pickup() -> void:
	Globals.mouse_down_unix_time = Time.get_unix_time_from_system()
	super()
	
	
func _drop() -> void:
	_check_valid_drop()
	super()


func _check_valid_drop():
	# Fail the drop if we're not over a cell
	if not Globals.hovered_cell:
		return
		
	# Fail the drop if we're not over an empty cell
	if Globals.hovered_cell.occupying_tile:
		# We might be over the tile we started on, 
		# so now check if we're within the click window 
		# to show tile info
		if (Globals.hovered_cell == host_cell 
		and Time.get_unix_time_from_system() - Globals.mouse_down_unix_time < click_window_time):
			Events.tile_clicked_for_info.emit(self)
			
		return
		
	# We're over an empty cell, so succeed the drop!
	# Remove this tile from the previous host cell if needed
	attach_to_cell(Globals.hovered_cell)


func attach_to_cell(cell: Cell) -> void:
	if host_cell:
		host_cell.occupying_tile = null
		
	# Give this tile to the new host cell
	host_cell = cell
	cell.occupying_tile = self
	
	set_home_location(cell.global_position)
