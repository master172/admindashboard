extends Control


func _on_back_pressed() -> void:
	var Dashboard:PackedScene = load("res://src/Main/Main.tscn")
	get_tree().change_scene_to_packed(Dashboard)


func _on_event_button_pressed() -> void:
	var registrations:PackedScene = load("res://src/Main/registrations.tscn")
	get_tree().change_scene_to_packed(registrations)
