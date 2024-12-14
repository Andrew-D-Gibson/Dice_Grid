class_name Dice
extends Holdable

@export var value: int = 0

var destroy_particles := preload('res://Source/Dice/destroy_particles.tscn')

func _ready() -> void:
	super()
	if value == 0:
		randomize_value()
	$AnimatedSprite2D.frame = value
	

func randomize_value() -> void:
	value = randi_range(1,6)
	$AnimatedSprite2D.frame = value


func _drop() -> void:
	_check_valid_drop()
	super()


func _check_valid_drop():
	# Fail the drop if we're not over a cell
	if not Globals.hovered_cell:
		return
		
	# Fail the drop if we're not over a tile
	if not Globals.hovered_cell.occupying_tile:
		return
		
	# Try to activate using the dice
	# If it fails the dice will return to its previous location
	# If it succeeds the dice will be destroyed
	Globals.hovered_cell.occupying_tile.check_activation(self)
		

func destroy():
	Events.remove_die_from_queue.emit(self)
	
	var particles = destroy_particles.instantiate()
	particles.position = global_position
	add_sibling(particles)
	particles.emitting = true
	
	queue_free()
