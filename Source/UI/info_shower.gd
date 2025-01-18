extends Control

@export var dice_image_paths: Array[String]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = false
	
	Events.show_info.connect(_show_info)
	

func _show_info(top_label_text: String, texture: Texture2D, bottom_label_text: String, title_label_text: String = "", secondary_texture: Texture2D = null) -> void:
	top_label_text = _format_text(top_label_text)
	bottom_label_text = _format_text(bottom_label_text)
	
	$"MarginContainer/VBoxContainer/Title Label".text = title_label_text
	$"MarginContainer/VBoxContainer/Top Label".text = top_label_text
	$"MarginContainer/VBoxContainer/MarginContainer/Main Display".texture = texture
	if secondary_texture:
		$"MarginContainer/VBoxContainer/MarginContainer/Secondary Display".visible = true
		$"MarginContainer/VBoxContainer/MarginContainer/Secondary Display".texture = secondary_texture
	else:
		$"MarginContainer/VBoxContainer/MarginContainer/Secondary Display".visible = false
	$"MarginContainer/VBoxContainer/Bottom Label".text = bottom_label_text
	self.visible = true


func _format_text(text: String) -> String:
	# Change colors to match the palette
	text = text.replace("red", "#d03656")
	text = text.replace("blue", "#43a6fc")
	text = text.replace("green", "#7abd33")
	text = text.replace("yellow", "#eed35d")
	text = text.replace("purple", "#c552f1")
	
	# Add dice images to replace numbers
	text = text.replace('(die_blank)', '[img={24}x{24}]' + dice_image_paths[0] + '[/img]')
	text = text.replace('(die_1)', '[img={24}x{24}]' + dice_image_paths[1] + '[/img]')
	text = text.replace('(die_2)', '[img={24}x{24}]' + dice_image_paths[2] + '[/img]')
	text = text.replace('(die_3)', '[img={24}x{24}]' + dice_image_paths[3] + '[/img]')
	text = text.replace('(die_4)', '[img={24}x{24}]' + dice_image_paths[4] + '[/img]')
	text = text.replace('(die_5)', '[img={24}x{24}]' + dice_image_paths[5] + '[/img]')
	text = text.replace('(die_6)', '[img={24}x{24}]' + dice_image_paths[6] + '[/img]')
	
	return text

func _on_screen_dim_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		self.visible = false
