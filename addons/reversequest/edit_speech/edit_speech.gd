extends Control


onready var store = $SceneSwitcherStore
onready var text = $MarginContainer/HBoxContainer/VBoxContainer/TextEdit


var _res


func _ready():
	_res = store.send_data[0]
	fill()


func fill():
	text.text = _res.text


func _on_apply_pressed():
	_res.text = text.text
	
	_res.emit_changed()
