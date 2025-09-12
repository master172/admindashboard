extends PanelContainer

@onready var label: Label = $MarginContainer/Participants/Label
@onready var name_label: Label = $MarginContainer/Participants/VboxContainer/Name/Data/name_label
@onready var email_label: Label = $MarginContainer/Participants/VboxContainer/EmailId/Data/email_label
@onready var phone_no: Label = $MarginContainer/Participants/VboxContainer/PhoneNo/Data/phone_no
@onready var reg_number: HBoxContainer = $MarginContainer/Participants/VboxContainer/reg_number
@onready var reg_label: Label = $MarginContainer/Participants/VboxContainer/reg_number/Data/reg_label

func _set_data(num:int=0,Name:String="",PhoneNo:String="",EmaiId:String="",reg_no:String = ""):
	label.text = "participant "+str(num)
	name_label.text = Name
	phone_no.text = PhoneNo
	email_label.text = EmaiId
	reg_number.visible = false if reg_no == "" else true
	reg_label.text = reg_no
