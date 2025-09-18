extends Control


var registration_uid:String = ""
@onready var uid_entry: LineEdit = $MainContainer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/UidEntry
@onready var overlay: Control = $Overlay
@onready var label: RichTextLabel = $Overlay/CenterContainer/PanelContainer/VBoxContainer/ColorRect/MarginContainer/VBoxContainer/Label

func _ready():
	overlay.hide()
	
func _on_uid_entry_text_submitted(new_text: String) -> void:
	registration_uid = new_text


func _on_submit_pressed() -> void:
	registration_uid = uid_entry.text
	var http :HTTPRequest = HTTPRequest.new()
	add_child(http)
	overlay.show()
	http.request_completed.connect(self.fecth_fees)
	http.request_completed.connect(http.queue_free.unbind(4))
	var err = http.request(Utils.default_backend_url+"fees/"+registration_uid)
	if err != OK:
		overlay.hide()
		OS.alert("http request error: ",err)

func fecth_fees(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var data:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if data != {}:
			var fees :int = data["fees"]
			display_fees(fees)
	else:
		if response_code == 404:
			OS.alert("No registration found, check uid")
		else:
			OS.alert("response erorr code: "+str(response_code))

func format_amount_indian(amount: int) -> String:
	var string:String = str(amount)
	var len :int = string.length()
	
	if len <= 3:
		return string
	
	var last_three :String = string.substr(len-3,3)
	var remaining :String = string.substr(0,len-3)
	
	var result :String = ""
	while remaining.length() > 2:
		result += "," + remaining.substr(remaining.length() - 2, 2) + result
		remaining = remaining.substr(0,remaining.length()-2)
	
	if remaining.length()>0:
		result = remaining + result
		
	return result + ","+last_three
	


func display_fees(fees:int):
	var formatted_currency:String = format_amount_indian(fees)
	label.text =  "The amount required to be paid is\n₹[b][color=yellow]" +formatted_currency + "[/color][/b]"
	overlay.show()

func _on_ok_pressed() -> void:
	uid_entry.text = ""
	label.text = ""
	overlay.hide()


func _on_back_pressed() -> void:
	var main_scene:PackedScene = load("res://src/Main/Main.tscn")
	get_tree().change_scene_to_packed(main_scene)
