extends VBoxContainer

const TEAM_HEADER = preload("res://src/UIComponents/TeamHeader.tscn")
const PARTICIPANT_ENTRY = preload("res://src/UIComponents/ParticipantEntry.tscn")

@onready var participant_container: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var cred: Label = $Header/MarginContainer/Cred
@onready var delegate_head: PanelContainer = $HBoxContainer/VBoxContainer/DelegateHead

var temp = {
	"college_name":{
		"cred_id":{
			"password":"password"
		},
		"delegate_name":"delegate_name",
		"delegate_email":"delegate_email",
		"delegate_phoneNo":"delegate_phoneNo",
		"event_name":{
			"cred_id":{
				"password":"password"
			},
			"participants":{
				"team 1":{
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
					}
				},
				"team 2":{
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
					}
				}
			}
		}
	}
}

func _ready() -> void:
	_load_data("Mcc",temp["college_name"])

func _load_data(Name:String,data_map:Dictionary)->void:
	cred.text = Name
	var num:int = 0
	var delegate_name:String = data_map["delegate_name"]
	var delegate_phone_no:String = data_map["delegate_phoneNo"]
	var delgate_email:String = data_map["delegate_email"]
	
	delegate_head._set_data(delegate_name,delegate_phone_no,delgate_email)
	var data :Dictionary = data_map["event_name"]["participants"]
	
	for i:String in data.keys():
		var team_handle = TEAM_HEADER.instantiate()
		participant_container.add_child(team_handle)
		team_handle._set_data(i)
		for j:String in data[i].keys():
			num += 1
			var data_name:String = data[i][j]["name"]
			var data_email:String = data[i][j]["email"]
			var data_phone_no:String = data[i][j]["phoneNo"]
		
			var entry:Node = PARTICIPANT_ENTRY.instantiate()
			
			participant_container.add_child(entry)
			entry._set_data(num,data_name,data_phone_no,data_email)
		participant_container.add_child(HSeparator.new())
		
