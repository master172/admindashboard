extends PanelContainer

@onready var margin_container: MarginContainer = $VBoxContainer/MarginContainer

func _ready() -> void:
	margin_container.visible = false
	
func _on_password_update_button_pressed() -> void:
	margin_container.visible = not margin_container.visible
