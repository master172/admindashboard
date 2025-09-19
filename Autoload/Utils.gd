extends Node

var register_form:Queue = Queue.new()
var selected_event:Queue = Queue.new()
var selected_club:Queue = Queue.new()
var selected_host:Queue = Queue.new()
var event_id:Queue = Queue.new()

const default_backend_url:String = "http://127.0.0.1:8000/"

func is_valid_email_id(email:String)->bool:
	var regex := RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null
	
func is_valid_phone_number(phone: String) -> bool:
	var regex := RegEx.new()
	regex.compile("^\\+?\\d{1,4}?[-.\\s]?\\(?\\d{1,3}?\\)?[-.\\s]?\\d{1,4}[-.\\s]?\\d{1,4}[-.\\s]?\\d{1,9}$")
	return regex.search(phone) != null

func is_whitespace(string:String) -> bool:
	var regex :RegEx = RegEx.new()
	regex.compile("^\\s*$")
	return regex.search(string) != null

func has_property(node:Node,property:String):
	for i in node.get_property_list():
		if i.name == property:
			return true
	return false
