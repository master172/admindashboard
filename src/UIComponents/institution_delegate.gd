extends VBoxContainer

const TEAM_HEADER = preload("res://src/UIComponents/TeamHeader.tscn")
const PARTICIPANT_ENTRY = preload("res://src/UIComponents/ParticipantEntry.tscn")

@onready var participant_container: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var cred: Label = $Header/MarginContainer/Cred
@onready var delegate_head: PanelContainer = $HBoxContainer/VBoxContainer/DelegateHead

func _load_data(data_map:Dictionary)->void:
	cred.text = data_map["institution_name"]
	var num:int = 0
	var delegate_name:String = data_map["delegate_head"]
	var delegate_phone_no:String = data_map["delegate_phone_no"]
	var delgate_email:String = data_map["delegate_email_id"]
	
	delegate_head._set_data(delegate_name,delegate_phone_no,delgate_email)
	var data :Array = data_map["teams"]
	
	var teams:int = 0
	for i:Dictionary in data:
		num = 0
		teams += 1
		var team_handle = TEAM_HEADER.instantiate()
		participant_container.add_child(team_handle)
		team_handle._set_data("Team_"+str(teams))
		for j:Dictionary in i["participants"]:
			num += 1
			var data_name:String = j.get("name", "")
			var data_phone_no:String = j.get("phone_no", "")
			var data_email:String = j.get("email_id", "")
			var data_reg_no:String = j.get("reg_no","")
			var entry:Node = PARTICIPANT_ENTRY.instantiate()
				
			participant_container.add_child(entry)
			entry._set_data(num,data_name,data_phone_no,data_email,data_reg_no)
		participant_container.add_child(HSeparator.new())
		
