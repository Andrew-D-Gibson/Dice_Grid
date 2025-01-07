extends Control

@onready var line_edit := $PanelContainer/VBoxContainer/LineEdit
@onready var command_history := $PanelContainer/VBoxContainer/RichTextLabel

func _ready() -> void:
	Events.dev_console_toggled.connect(_toggle_dev_console)
	
	
func _toggle_dev_console() -> void:
	visible = !visible
	
	if visible:
		line_edit.grab_focus()
		line_edit.text = ''


func _on_line_edit_text_submitted(console_command: String) -> void:
	# Add to the history
	command_history.append_text('\n' + console_command)
	
	
	# Handle commands
	var command = console_command.split(' ')
	match command[0]:
		'heal':
			Globals.player.change_health(1000)
			command_history.append_text('\n[center][i]Healed Player[/i][/center]')
			
			
	# Clear the line edit for further commands and re-enter the edit mode
	line_edit.text = ''
	line_edit.edit.call_deferred()


func _on_line_edit_text_changed(current_text: String) -> void:
	if current_text.contains('`'):
		current_text.replace('`', '')
		visible = !visible
