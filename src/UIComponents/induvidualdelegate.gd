extends VBoxContainer

const PARTICIPANT_ENTRY = preload("res://src/UIComponents/ParticipantEntry.tscn")
@onready var participant_container: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var cred: Label = $Header/MarginContainer/Cred

var temp = {
	"cred_id":{
			"user_id":"value",
			"Password":"password",
		},
			"participants":{
				"participant 1":{
					"name":"Name",
					"email":"Email",
					"phoneNo":"Phone No"
				},
				"participant 2":{
					"name":"Name",
					"email":"Email",
					"phoneNo":"Phone No"
				},
				"participant 3":{
					"name":"Name",
					"email":"Email",
					"phoneNo":"Phone No"
				},
				"participant n":{
					"name":"Name",
					"email":"Email",
					"phoneNo":"Phone No"
				},
			   
			}
}

func _ready() -> void:
	_load_data(temp)

func _load_data(data:Dictionary)->void:
	cred.text = data["cred_id"]["user_id"]
	var num:int = 0
	for i:String in data["participants"].keys():
		num += 1
		var data_name:String = data["participants"][i]["name"]
		var data_email:String = data["participants"][i]["email"]
		var data_phone_no:String = data["participants"][i]["phoneNo"]
	
		var entry:Node = PARTICIPANT_ENTRY.instantiate()
		
		participant_container.add_child(entry)
		entry._set_data(num,data_name,data_phone_no,data_email)
