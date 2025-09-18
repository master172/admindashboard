extends Control

@onready var items: FlowContainer = $VBoxContainer/MarginContainer/ScrollContainer/Items
const CLUB_BUTTON = preload("res://src/UIComponents/ClubButton.tscn")

func _ready() -> void:
	get_all_clubs()
	
func _on_back_pressed() -> void:
	var Dashboard:PackedScene = load("res://src/Main/Main.tscn")
	get_tree().change_scene_to_packed(Dashboard)


func _on_registration_button_pressed(club:String) -> void:
	Utils.selected_club.enqueue(club)
	var manage_events:PackedScene = load("res://src/Main/manage_events.tscn")
	get_tree().change_scene_to_packed(manage_events)

func get_all_clubs():
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._on_club_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var err = http.request(Utils.default_backend_url+"clubs")
	if err != OK:
		push_error("http request error: ",err)
	
func _on_club_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Array = JSON.parse_string(body.get_string_from_utf8())
		print(data)
		if data != []:
			add_club_buttons(data)
	else:
		push_error("request failed response code: ",response_code)

func add_club_buttons(data:Array):
	for i in data:
		var club_button = CLUB_BUTTON.instantiate()
		club_button.Text = i
		club_button.string_identifier = i
		club_button.pressed.connect(self._on_registration_button_pressed.bind(club_button.string_identifier))
		items.add_child(club_button)
