extends Control

func _on_manage_events_pressed() -> void:
	var Manage_events_scene:PackedScene = load("res://src/Main/manage_hosts.tscn")
	get_tree().change_scene_to_packed(Manage_events_scene)


func _on_registrations_button_pressed() -> void:
	var Manage_Registrations_scene:PackedScene = load("res://src/Main/manage_clubs.tscn")
	get_tree().change_scene_to_packed(Manage_Registrations_scene)
