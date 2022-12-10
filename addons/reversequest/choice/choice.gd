extends Node2D

var config = preload("res://addons/reversequest/choice/config.gd")

signal update_order
signal link(res)
signal link_create(res)


onready var link = $Control/VBoxContainer2/Link
onready var create = $Control/VBoxContainer2/Create

var _controller
var res
var rect setget , _get_rect


func setup(_res, controller):
	res = _res
	_controller = controller
	get_node("%SceneSwitcherActorEdit").send_data = [res]
	fill_res()
	res.connect("changed", self, "_on_res_changed")


func fill_res():
	$Control/Label.text = res.text
	$Debug/Code.text = str(res.code)


func _on_Link_pressed():
	emit_signal("link", res)
	link.hide()
	create.show()


func _on_Create_pressed():
	emit_signal("link_create", res)
	create.hide()
	link.show()


func _on_res_changed():
	fill_res()

func _get_rect():
	return Rect2(position, $Control.rect_size)
