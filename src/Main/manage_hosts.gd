extends Control

const HOST_BUTTON = preload("res://src/UIComponents/HostButton.tscn")

@onready var items: FlowContainer = $VBoxContainer/MarginContainer/ScrollContainer/Items

var hosts:Dictionary = {}

func _ready() -> void:
	get_all_hosts()
	
func get_all_hosts():
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._on_hosts_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var err = http.request("http://127.0.0.1:8000/hosts")
	if err != OK:
		push_error("http request error: ",err)
	
func _on_hosts_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		hosts = data
		add_host_managers()
	else:
		push_error("request failed response code: ",response_code)

func add_host_managers():
	for i in hosts.keys():
		var button = HOST_BUTTON.instantiate()
		button.string_identifier = i
		button.pressed.connect(self._on_host_button_pressed.bind(button.string_identifier))
		button.Text = hosts[i]
		items.add_child(button)
		

func _on_back_pressed() -> void:
	var Dashboard:PackedScene = load("res://src/Main/Main.tscn")
	get_tree().change_scene_to_packed(Dashboard)


func _on_host_button_pressed(string_identifer:String) -> void:
	Utils.selected_host.enqueue(string_identifer)
	var creator:PackedScene = load("res://src/Main/create_host.tscn")
	get_tree().change_scene_to_packed(creator)


func _on_creation_button_pressed() -> void:
	var creator:PackedScene = load("res://src/Main/create_host.tscn")
	get_tree().change_scene_to_packed(creator)
