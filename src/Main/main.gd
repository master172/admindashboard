extends Control

func _on_manage_events_pressed() -> void:
	var Manage_events_scene:PackedScene = load("res://src/Main/manage_hosts.tscn")
	get_tree().change_scene_to_packed(Manage_events_scene)


func _on_registrations_button_pressed() -> void:
	attemt_permission()
	
func change_scene_to_register()->void:
	var Manage_Registrations_scene:PackedScene = load("res://src/Main/manage_clubs.tscn")
	get_tree().change_scene_to_packed(Manage_Registrations_scene)
	
func attemt_permission():
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self.permission_granted)
	http.request_completed.connect(http.queue_free.unbind(4))
	var err = http.request("http://127.0.0.1:8000/check_time")
	if err != OK:
		push_error("http request error: ",err)
	
func permission_granted(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:bool = JSON.parse_string(body.get_string_from_utf8())
		if data == true:
			change_scene_to_register()
		else:
			OS.alert("You do not have permission to view registrations yet")
	else:
		push_error("request failed response code: ",response_code)
