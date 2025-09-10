extends Control

const EVENT_BUTTON_COMPONENT = preload("res://src/UIComponents/EventButtonComponent.tscn")

@onready var items: FlowContainer = $VBoxContainer/MarginContainer/ScrollContainer/Items

var selected_club:String = ""
func _on_back_pressed() -> void:
	var Dashboard:PackedScene = load("res://src/Main/manage_clubs.tscn")
	get_tree().change_scene_to_packed(Dashboard)

func _ready() -> void:
	if Utils.selected_club.is_empty() == false:
		selected_club = Utils.selected_club.get_front()
		attemt_events_creation()
		
func _on_event_button_pressed() -> void:
	var registrations:PackedScene = load("res://src/Main/registrations.tscn")
	get_tree().change_scene_to_packed(registrations)

func attemt_events_creation():
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._on_request_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var header = ["Content-Type: application/json"]
	var body:String = JSON.stringify({"club_name":selected_club})
	var err = http.request("http://127.0.0.1:8000/events",header,HTTPClient.METHOD_GET,body)
	if err != OK:
		push_error("http request error: ",err)
	
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if data != {}:
			add_event_buttons(data)
	else:
		push_error("request failed response code: ",response_code)

func add_event_buttons(button_entries:Dictionary)->void:
	for i in button_entries.keys():
		var button:Node = EVENT_BUTTON_COMPONENT.instantiate()
		button.string_identifier = i
		button.pressed.connect(self.on_event_button_pressed.bind(button_entries[i],selected_club))
		button.Text = button_entries[i]
		items.add_child(button)

func on_event_button_pressed(event_id:String,club_id:String)->void:
	Utils.selected_event.enqueue(event_id)
	Utils.selected_club.enqueue(club_id)
	_on_event_button_pressed()
