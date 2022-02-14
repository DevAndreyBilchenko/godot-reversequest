extends Node2D

signal update_order(diff)
signal edit_open(data)

var data = null
var size_y = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_data(_data):
	data = _data
	
func fill_data():
	get_node("Control/Label").text = data.text;

func _on_Edit_pressed():
	emit_signal("edit_open", data);

func _on_Up_pressed():
	emit_signal("update_order", -1);

func _on_Down_pressed():
	emit_signal("update_order", 1);
