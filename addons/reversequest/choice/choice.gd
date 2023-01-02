extends Control

signal doubleclick

const GROUP_REQUESTER = "speech_link_request"
const GROUP_ZONE = "speech_link_zone"

export(NodePath) var button_create_np
export(NodePath) var button_link_np
export(NodePath) var button_unlink_np
export(NodePath) var button_cancel_np
export(NodePath) var button_remove_np

var res
var state_list = preload("res://addons/reversequest/choice/choice_state_list.gd").new()

var _button_create
var _button_link
var _button_unlink
var _button_cancel
var _button_remove
var _class_list
var _controller
var _speech_code


func _ready():
	_button_create = get_node(button_create_np)
	_button_link = get_node(button_link_np)
	_button_unlink = get_node(button_unlink_np)
	_button_cancel = get_node(button_cancel_np)
	_button_remove = get_node(button_remove_np)
	
	state_list.connect("link_updated", self, "_on_state_list_link_updated")
	state_list.connect("deletable_updated", self, "_on_state_list_deletable_updated")
	_class_list.renderer.connect("render_done", self, "_on_render_done")


func setup(_res, class_list, speech_code):
	res = _res
	_class_list = class_list
	_controller = _class_list.dialog_res_controller
	_speech_code = speech_code
	
	if not is_inside_tree():
		yield(self, "ready")
	
	get_node("SceneSwitcherActorEdit").send_data = [res]
	
	if res.link == -1:
		state_list.link = state_list.LINK_UNLINKED
	else:
		_connect_to_linked_speech()
		state_list.link = state_list.LINK_LINKED


func link_to(speech_res):
	get_tree().call_group(GROUP_ZONE, "hide")
	remove_from_group(GROUP_REQUESTER)
	res.link = speech_res.code
	res.emit_changed()
	_controller.emit_structure_update()
	_connect_to_linked_speech()
	state_list.link = state_list.LINK_LINKED


func _enable_link_watcher():
	get_tree().call_group(GROUP_ZONE, "show")
	add_to_group(GROUP_REQUESTER)


func _disable_link_watcher():
	get_tree().call_group(GROUP_ZONE, "hide")
	remove_from_group(GROUP_REQUESTER)


func _connect_to_linked_speech():
	_get_linked_speech_node().connect("connections_changed", self, "_on_linked_speech_connections_changed")


func _disconnect_linked_speech():
	_get_linked_speech_node().disconnect("connections_changed", self, "_on_linked_speech_connections_changed")


func _get_linked_speech_node():
	return _class_list.renderer.find_speech_node(res.link)


func _update_deletable_state():
	if res.link != -1:
		var count = _class_list.renderer.get_connections_count(res.link)
		state_list.deletable = count > 1
	else:
		state_list.deletable = true


func _on_link_pressed():
	_enable_link_watcher()
	state_list.link = state_list.LINK_READY


func _on_create_pressed():
	_disable_link_watcher()
	var speech_res = _controller.create_speech()
	res.link = speech_res.code
	_controller.emit_structure_update()
	_connect_to_linked_speech()
	state_list.link = state_list.LINK_LINKED


func _on_cancel_pressed():
	_disable_link_watcher()
	state_list.link = state_list.LINK_UNLINKED


func _on_gui_input(event):
	if event is InputEventMouseButton and event.doubleclick == true:
		get_tree().set_input_as_handled()
		emit_signal("doubleclick")


func _on_remove_pressed():
	_disconnect_linked_speech()
	_controller.remove_choice(_speech_code, res.code)
	_controller.emit_structure_update()
	_get_linked_speech_node().emit_connections_changed()
	queue_free()


func _on_unlink_pressed():
	_disconnect_linked_speech()
	_controller.emit_structure_update()
	_get_linked_speech_node().emit_connections_changed()
	state_list.link = state_list.LINK_UNLINKED


func _on_state_list_link_updated():
	_button_create.hide()
	_button_link.hide()
	_button_unlink.hide()
	_button_cancel.hide()
	
	if state_list.link == state_list.LINK_UNLINKED:
		_button_link.show()
	elif state_list.link == state_list.LINK_LINKED:
		_button_unlink.show()
	elif state_list.link == state_list.LINK_READY:
		_button_cancel.show()
		_button_create.show()


func _on_state_list_deletable_updated():
	_button_remove.disabled = state_list.deletable
	_button_unlink.disabled = state_list.deletable


func _on_structure_update():
	if state_list.link == state_list.LINK_LINKED:
		_class_list.renderer.get_connections_count()
	
	
func _on_linked_speech_connections_changed():
	_update_deletable_state()
