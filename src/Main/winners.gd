extends Control

var selected_event:String = ""
var selected_club:String = ""
var event_id:String = ""

var INDIVIDUAL_REGISTRATIONS:Dictionary = {}
var INSTITUTION_REGISTRATIONS:Dictionary = {}

const INDUVIDUALDELEGATE = preload("res://src/UIComponents/Induvidualdelegate.tscn")
const INSTITUTION_DELEGATE = preload("res://src/UIComponents/InstitutionDelegate.tscn")

@onready var place_1_container: PanelContainer = $VBoxContainer/ScrollContainer/VBoxContainer/Place1
@onready var place_2_container: PanelContainer = $VBoxContainer/ScrollContainer/VBoxContainer/Place2
@onready var place_3_container: PanelContainer = $VBoxContainer/ScrollContainer/VBoxContainer/Place3

var data_to_save:Dictionary = {
	"first_place":{
		"type":"",
		"uid":"",
	},
	"second_place":{
		"type":"",
		"uid":"",
	},
	"third_place":{
		"type":"",
		"uid":"",
	},
}

var uid_type_index:Dictionary = {}

var uid_individual_index:Dictionary = {}
var uid_institution_index:Dictionary = {}

var registrations_loaded:int = 0

func _ready() -> void:
	if Utils.selected_event.size() != 0:
		selected_event = Utils.selected_event.get_front()
	if Utils.event_id.size() != 0:
		event_id = Utils.event_id.get_front()
	if Utils.selected_club.size() != 0:
		selected_club = Utils.selected_club.get_front()
		
		get_individual_registrations()
		get_institution_registrations()
		

func _check_all_registrations_loaded() -> void:
	if registrations_loaded >= 2:
		get_winners()


func get_individual_registrations()->void:
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self.induvidual_request_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var club = selected_club.uri_encode()
	var event = selected_event.uri_encode()
	var url:String = Utils.default_backend_url+"registrations/individual/"+club+"/"+event
	var err = http.request(url)
	if err != OK:
		push_error("http request error: ",err)
	
func induvidual_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		add_individual_registrations(data)
	else:
		if response_code == 404:
			OS.alert("No individual registrations found")
			registrations_loaded += 1
			_check_all_registrations_loaded()
		else:
			push_error("request failed response code: ",response_code)

func get_institution_registrations()->void:
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self.institution_request_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var club = selected_club.uri_encode()
	var event = selected_event.uri_encode()
	var url:String = Utils.default_backend_url+"registrations/institution/"+club+"/"+event
	var err = http.request(url)
	if err != OK:
		push_error("http request error: ",err)
	
func institution_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		add_institution_registrations(data)
	else:
		if response_code == 404:
			OS.alert("No institution registrations found")
			registrations_loaded += 1
			_check_all_registrations_loaded()
		else:
			push_error("request failed response code: ",response_code)

func add_individual_registrations(data:Dictionary)->void:
	var registration_ids:Array[String] = []
	var running_total:int = 0
	INDIVIDUAL_REGISTRATIONS = data
	for i in INDIVIDUAL_REGISTRATIONS["registrations"]:
		registration_ids.append(i["registration_id"])
		uid_type_index[i["registration_id"]] = "individual"
		uid_individual_index[i["registration_id"]] = running_total
		running_total += 1
	
	registrations_loaded += 1
	_check_all_registrations_loaded()
	
func add_institution_registrations(data:Dictionary)->void:
	var registration_ids:Array[String] = []
	var running_total:int = 0
	INSTITUTION_REGISTRATIONS = data
	for i in INSTITUTION_REGISTRATIONS["registrations"]:
		registration_ids.append(i["registration_id"])
		uid_type_index[i["registration_id"]] = "institution"
		uid_institution_index[i["registration_id"]] = running_total
		running_total += 1
	
	registrations_loaded += 1
	_check_all_registrations_loaded()
	
func _on_back_pressed() -> void:
	Utils.selected_club.enqueue(selected_club)
	var Go_To_Winners :PackedScene = load("res://src/Main/winners_event_selector.tscn")
	get_tree().change_scene_to_packed(Go_To_Winners)

func get_winners()->void:
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self.load_fetched_winners_data)
	http.request_completed.connect(http.queue_free.unbind(4))
	var club = selected_club.uri_encode()
	var event = event_id.uri_encode()
	var url :String= Utils.default_backend_url+"get_winners/"+club+"/"+event
	var err = http.request(url)
	if err != OK:
		push_error("http request error: ",err)
		
func load_fetched_winners_data(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if data != {}:
			data_to_save = data
			parse_fetched_data(data)
	else:
		if response_code == 404:
			OS.alert("no winners found")
		else:
			push_error("request failed response code: ",response_code)


func parse_fetched_data(data:Dictionary) -> void:
	# First Place
	if data.has("first_place") and data["first_place"]["uid"] != "":
		var uid = data["first_place"]["uid"]
		var type = data["first_place"]["type"]

		for c in place_1_container.get_children():
			c.queue_free()

		if type == "individual":
			var delegate:Node = INDUVIDUALDELEGATE.instantiate()
			place_1_container.add_child(delegate)
			delegate._load_data(INDIVIDUAL_REGISTRATIONS["registrations"][uid_individual_index[uid]])
		elif type == "institution":
			var delegate:Node = INSTITUTION_DELEGATE.instantiate()
			place_1_container.add_child(delegate)
			delegate._load_data(INSTITUTION_REGISTRATIONS["registrations"][uid_institution_index[uid]])
	
	# Second Place
	if data.has("second_place") and data["second_place"]["uid"] != "":
		var uid = data["second_place"]["uid"]
		var type = data["second_place"]["type"]

		for c in place_2_container.get_children():
			c.queue_free()

		if type == "individual":
			var delegate:Node = INDUVIDUALDELEGATE.instantiate()
			place_2_container.add_child(delegate)
			delegate._load_data(INDIVIDUAL_REGISTRATIONS["registrations"][uid_individual_index[uid]])
		elif type == "institution":
			var delegate:Node = INSTITUTION_DELEGATE.instantiate()
			place_2_container.add_child(delegate)
			delegate._load_data(INSTITUTION_REGISTRATIONS["registrations"][uid_institution_index[uid]])

	# Third Place
	if data.has("third_place") and data["third_place"]["uid"] != "":
		var uid = data["third_place"]["uid"]
		var type = data["third_place"]["type"]

		for c in place_3_container.get_children():
			c.queue_free()

		if type == "individual":
			var delegate:Node = INDUVIDUALDELEGATE.instantiate()
			place_3_container.add_child(delegate)
			delegate._load_data(INDIVIDUAL_REGISTRATIONS["registrations"][uid_individual_index[uid]])
		elif type == "institution":
			var delegate:Node = INSTITUTION_DELEGATE.instantiate()
			place_3_container.add_child(delegate)
			delegate._load_data(INSTITUTION_REGISTRATIONS["registrations"][uid_institution_index[uid]])
