extends Control

func _on_back_pressed() -> void:
	var event_manager = load("res://src/Main/manage_clubs.tscn")
	get_tree().change_scene_to_packed(event_manager)
