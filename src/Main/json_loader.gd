extends Node

func load_json_as_dict(path:String)->Dictionary:
	var file = FileAccess.open(path,FileAccess.READ)
	if file == null:
		push_error("coudn't open file: "+path)
		return {}
	
	var text :String = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(text)
	if data == null or typeof(data) != TYPE_DICTIONARY:
		push_error("an array of strings expected check file path or contents")
		return {}
		
	return data
	
