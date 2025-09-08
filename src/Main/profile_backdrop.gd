extends PanelContainer

@onready var user_id: Label = $HBoxContainer/VBoxContainer/UserId
@onready var club: Label = $HBoxContainer/VBoxContainer/Club

func _set_data() -> void:
	user_id.text = Utils.user_id
