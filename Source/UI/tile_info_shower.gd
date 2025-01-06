extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = false
	
	Events.tile_clicked_for_info.connect(_show_tile_info)
	
	
func _show_tile_info(tile: Tile):
	$"VBoxContainer/Tile Display".texture = tile.tile_texture
	$VBoxContainer/Label.text = tile.description
	self.visible = true


func _on_screen_dim_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		self.visible = false
