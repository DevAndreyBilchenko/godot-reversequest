extends Control

signal open(id)

var id = ""

func set_data(name, _id):
	$Container/Label.text = name
	id = _id

func _on_Button_pressed():
	emit_signal("open", id)
