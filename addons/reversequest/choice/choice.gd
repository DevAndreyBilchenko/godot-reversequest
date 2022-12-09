extends Node2D

var config = preload("res://addons/reversequest/choice/config.gd")

signal update_order
signal edit_open(res)
signal link(res)
signal link_create(res)


onready var link = $Control/VBoxContainer2/Link
onready var create = $Control/VBoxContainer2/Create


var res
var rect setget , _get_rect


func set_res(_res):
	res = _res
	#yield(get_tree(), "idle_frame")
	fill_res()


func fill_res():
	$Control/Label.text = res.text
	$Debug/Code.text = str(res.code)


func _on_EditTrigger_dbclick():
	emit_signal("edit_open", res)


func _on_Link_pressed():
	emit_signal("link", res)
	link.hide()
	create.show()


func _on_Create_pressed():
	emit_signal("link_create", res)
	create.hide()
	link.show()


func _get_rect():
	return Rect2(position, $Control.rect_size)
