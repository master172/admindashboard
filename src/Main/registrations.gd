extends Control
const INDUVIDUALDELEGATE = preload("res://src/UIComponents/Induvidualdelegate.tscn")
const INSTITUTION_DELEGATE = preload("res://src/UIComponents/InstitutionDelegate.tscn")

@onready var individuals: VBoxContainer = $VBoxContainer/MarginContainer/TabContainer/Induvidual/FormContainer/individual
@onready var institutions: VBoxContainer = $VBoxContainer/MarginContainer/TabContainer/Institution/FormContainer/institution

var selected_event:String = ""
var selected_club:String = ""

func _on_back_pressed() -> void:
	Utils.selected_club.enqueue(selected_club)
	var event_manager = load("res://src/Main/manage_events.tscn")
	get_tree().change_scene_to_packed(event_manager)

func _ready() -> void:
	if Utils.selected_event.size() != 0:
		selected_event = Utils.selected_event.get_front()
		selected_club = Utils.selected_club.get_front()
		get_individual_registrations()
		get_institution_registrations()

func get_individual_registrations():
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self.induvidual_request_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var club = selected_club.uri_encode()
	var event = selected_event.uri_encode()
	var url:String = "http://127.0.0.1:8000/registrations/individual/"+club+"/"+event
	var err = http.request(url)
	if err != OK:
		push_error("http request error: ",err)
	
func induvidual_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		add_individual_registration(data)
	else:
		push_error("request failed response code: ",response_code)

func get_institution_registrations():
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self.institution_request_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var club = selected_club.uri_encode()
	var event = selected_event.uri_encode()
	var url:String = "http://127.0.0.1:8000/registrations/institution/"+club+"/"+event
	var err = http.request(url)
	if err != OK:
		push_error("http request error: ",err)
	
func institution_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		add_institution_registrations(data)
	else:
		push_error("request failed response code: ",response_code)

func add_individual_registration(data:Dictionary)->void:
	for i in data["registrations"]:
		var delegate:Node = INDUVIDUALDELEGATE.instantiate()
		individuals.add_child(delegate)
		delegate._load_data(i)

func add_institution_registrations(data:Dictionary)->void:
	for i in data["registrations"]:
		var delegate:Node = INSTITUTION_DELEGATE.instantiate()
		institutions.add_child(delegate)
		delegate._load_data(i)
