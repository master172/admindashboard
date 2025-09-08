extends PanelContainer

@onready var name_label: Label = $MarginContainer/Participants/VboxContainer/Name/Data/name_label
@onready var email_label: Label = $MarginContainer/Participants/VboxContainer/EmailId/Data/email_label
@onready var phone_no: Label = $MarginContainer/Participants/VboxContainer/PhoneNo/Data/phone_no

func _set_data(Name:String="",PhoneNo:String="",EmaiId:String=""):
	name_label.text = Name
	phone_no.text = PhoneNo
	email_label.text = EmaiId
