extends PanelContainer

@onready var cred: Label = $MarginContainer/Cred

func _set_data(val:String)->void:
	cred.text = val
