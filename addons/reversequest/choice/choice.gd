extends Control

signal link(res)
signal link_create(res)

const GROUP_REQUESTER = "speech_link_request"
const GROUP_ZONE = "speech_link_zone"

onready var link = $Control/MarginContainer/HBoxContainer/VBoxContainer2/Link
onready var create = $Control/MarginContainer/HBoxContainer/VBoxContainer2/Create

var _controller
var res


func setup(_res, controller):
	res = _res
	_controller = controller
	get_node("%SceneSwitcherActorEdit").send_data = [res]


func link_to(speech_res):
	get_tree().call_group(GROUP_ZONE, "hide")
	remove_from_group(GROUP_REQUESTER)
	res.link = speech_res.code
	res.emit_changed()
	_controller.emit_structure_update()


func _on_link_pressed():
	get_tree().call_group(GROUP_ZONE, "show")
	add_to_group(GROUP_REQUESTER)


func _on_create_pressed():
	get_tree().call_group(GROUP_ZONE, "hide")
	remove_from_group(GROUP_REQUESTER)
	var speech_res = _controller.create_speech()
	res.link = speech_res.code
	_controller.emit_structure_update()


func _on_cancel_pressed():
	get_tree().call_group(GROUP_ZONE, "hide")
	remove_from_group(GROUP_REQUESTER)
