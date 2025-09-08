extends PanelContainer

signal rule_entered(rule:String)
@onready var line_edit: LineEdit = $HBoxContainer/LineEdit

var text:String:
	get:
		return line_edit.text

func _on_line_edit_text_submitted(new_text: String) -> void:
	if Utils.is_whitespace(new_text):
		OS.alert("please enter a valid string")
		line_edit.text = ""
		line_edit.release_focus()
		return
	emit_signal("rule_entered",new_text)
	line_edit.release_focus()


func _on_button_pressed() -> void:
	queue_free()
