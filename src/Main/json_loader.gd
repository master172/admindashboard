extends Node

func load_json_as_array(path:String)->Array[String]:
	var file = FileAccess.open(path,FileAccess.READ)
	if file == null:
		push_error("coudn't open file: "+path)
		return []
	
	var text :String = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(text)
	if data == null or typeof(data) != TYPE_ARRAY:
		push_error("an array of strings expected check file path or contents")
		return []
	
	var result:Array[String]
	for value in data:
		if typeof(value) == TYPE_STRING:
			result.append(value)
	return result
	
