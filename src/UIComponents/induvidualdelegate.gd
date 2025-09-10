extends VBoxContainer

const PARTICIPANT_ENTRY = preload("res://src/UIComponents/ParticipantEntry.tscn")
@onready var participant_container: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var cred: Label = $Header/MarginContainer/Cred

func _load_data(data:Dictionary)->void:
	cred.text = data["team_name"]
	var num:int = 0
	for i:Dictionary in data["participants"]:
		num += 1
		var data_name:String = i["name"]
		var data_email:String = i["email_id"]
		var data_phone_no:String = i["phone_no"]
	
		var entry:Node = PARTICIPANT_ENTRY.instantiate()
		
		participant_container.add_child(entry)
		entry._set_data(num,data_name,data_phone_no,data_email)
