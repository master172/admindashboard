extends Control

@onready var club_name: OptionButton = $VBoxContainer/MarginContainer/ScrollContainer/FormContainer/club_name/MarginContainer/HBoxContainer/club_name
@onready var login_id: LineEdit = $VBoxContainer/MarginContainer/ScrollContainer/FormContainer/LoginId/MarginContainer/HBoxContainer/login_id
@onready var email_id: LineEdit = $VBoxContainer/MarginContainer/ScrollContainer/FormContainer/EmailID/MarginContainer/HBoxContainer/email_id
@onready var password: LineEdit = $VBoxContainer/MarginContainer/ScrollContainer/FormContainer/Password/MarginContainer/HBoxContainer/password

@onready var json_loader: Node = $JsonLoader
const CLUB_FILE = "res://Resources/club_names.json"

@onready var fields :Array[Node]= [
	club_name,
	login_id,
	email_id,
	password,
]

@onready var field_map:Dictionary[Node,String] = {
	club_name:"club_name",
	login_id:"login_id",
	email_id:"email_id",
	password:"password",
}

var data:Dictionary = {
	"user_uid":"",
	"club_name":"",
	"login_id":"",
	"email_id":"",
	"password":"",
}

var selected_host:String = ""

func _ready() -> void:
	var club_names = json_loader.load_json_as_dict(CLUB_FILE)
	for i in club_names.keys():
		club_name.add_item(i)
		
	if Utils.selected_host.is_empty() == false:
		selected_host = Utils.selected_host.get_front()
		get_host(selected_host)

	
		
func _on_back_pressed() -> void:
	var HostsManager:PackedScene = load("res://src/Main/manage_hosts.tscn")
	get_tree().change_scene_to_packed(HostsManager)


func _on_login_id_text_submitted(new_text: String) -> void:
	if Utils.is_whitespace(new_text):
		OS.alert("please enter valid login id")
		login_id.text = ""
		login_id.release_focus()
		return
	data["login_id"] = new_text
	login_id.release_focus()


func _on_email_id_text_submitted(new_text:String) -> void:
	if Utils.is_whitespace(new_text) or not Utils.is_valid_email_id(new_text):
		OS.alert("please enter valid Email id")
		email_id.text = ""
		email_id.release_focus()
		return
	data["email_id"] = new_text
	email_id.release_focus()


func _on_password_text_submitted(new_text: String) -> void:
	if Utils.is_whitespace(new_text):
		OS.alert("please enter valid password")
		password.text = ""
		password.release_focus()
		return
	data["password"] = new_text
	password.release_focus()


func _on_save_pressed() -> void:
	for i:Node in fields:
		data[field_map[i]] = i.text if Utils.has_property(i,"text") else i.get_item_text(i.selected)
	
	data["user_uid"] = selected_host if selected_host != "" else ""
	create_host(data)
	


func _on_club_name_item_selected(index: int) -> void:
	data["club_name"] = club_name.get_item_text(index)

func create_host(request_refrence:Dictionary):
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._on_hosts_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var header = ["Content-Type: application/json"]
	var body:String = JSON.stringify(request_refrence)
	var err = http.request("http://127.0.0.1:8000/create",header,HTTPClient.METHOD_POST,body)
	if err != OK:
		push_error("http request error: ",err)
	
func _on_hosts_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		_on_back_pressed()
	else:
		push_error("request failed response code: ",response_code)

func get_host(user_id:String):
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(self._on_host_completed)
	http.request_completed.connect(http.queue_free.unbind(4))
	var header = ["Content-Type: application/json"]
	var body:String = JSON.stringify({"user_id":user_id})
	var err = http.request("http://127.0.0.1:8000/host",header,HTTPClient.METHOD_GET,body)
	if err != OK:
		push_error("http request error: ",err)
	
func _on_host_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data :Dictionary = JSON.parse_string(body.get_string_from_utf8())
		set_values(data)
	else:
		push_error("request failed response code: ",response_code)

func set_values(data:Dictionary)->void:
	var club_names = json_loader.load_json_as_dict(CLUB_FILE)
	club_name.select(club_names[data["club_name"]])
	login_id.text = data["login_id"]
	email_id.text = data["email_id"]
	password.text = data["password"]
