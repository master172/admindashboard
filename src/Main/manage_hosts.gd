extends Control


func _on_back_pressed() -> void:
	var Dashboard:PackedScene = load("res://src/Main/Main.tscn")
	get_tree().change_scene_to_packed(Dashboard)


func _on_event_button_pressed() -> void:
	var creator:PackedScene = load("res://src/Main/create_host.tscn")
	get_tree().change_scene_to_packed(creator)


func _on_creation_button_pressed() -> void:
	var creator:PackedScene = load("res://src/Main/create_host.tscn")
	get_tree().change_scene_to_packed(creator)
