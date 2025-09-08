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

var entry_number:int = 1

var data:Dictionary = {
	"entry "+str(entry_number):{
		"club_name":"",
		"login_id":"",
		"email_id":"",
		"password":"",
	}
}

func _ready() -> void:
	var club_names = json_loader.load_json_as_array(CLUB_FILE)
	for i in club_names:
		club_name.add_item(i)
		
func _on_back_pressed() -> void:
	var HostsManager:PackedScene = load("res://src/Main/manage_hosts.tscn")
	get_tree().change_scene_to_packed(HostsManager)


func _on_login_id_text_submitted(new_text: String) -> void:
	if Utils.is_whitespace(new_text):
		OS.alert("please enter valid login id")
		login_id.text = ""
		login_id.release_focus()
		return
	data["entry "+str(entry_number)]["login_id"] = new_text
	login_id.release_focus()


func _on_email_id_text_submitted(new_text:String) -> void:
	if Utils.is_whitespace(new_text) or not Utils.is_valid_email_id(new_text):
		OS.alert("please enter valid Email id")
		email_id.text = ""
		email_id.release_focus()
		return
	data["entry "+str(entry_number)]["email_id"] = new_text
	email_id.release_focus()


func _on_password_text_submitted(new_text: String) -> void:
	if Utils.is_whitespace(new_text):
		OS.alert("please enter valid password")
		password.text = ""
		password.release_focus()
		return
	data["entry "+str(entry_number)]["password"] = new_text
	password.release_focus()


func _on_save_pressed() -> void:
	for i:Node in fields:
		data["entry "+str(entry_number)][field_map[i]] = i.text if Utils.has_property(i,"text") else i.get_item_text(i.selected)
	
	print("data")
	
	_on_back_pressed()


func _on_club_name_item_selected(index: int) -> void:
	data["entry "+str(entry_number)]["club_name"] = club_name.get_item_text(index)
