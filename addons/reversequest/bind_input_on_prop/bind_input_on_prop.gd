extends Node

signal prop_changed(new_val, old_val)

export(NodePath) var input
export(NodePath) var target
export(String) var prop
export(bool) var init_from_prop = true
export(bool) var ignore_changed = false
export(bool) var custom_update_prop = false
export(NodePath) var custom_target
export(String) var custom_signal


func _ready():
	yield(get_tree(), "idle_frame")
	_setup()
	
	
func _setup():
	var node = get_node(input)
	var val = ""
	
	if init_from_prop:
		var n = get_node(_join_np(target, prop))
		val = n.get_indexed(prop)
	
	if node is LineEdit or node is TextEdit:
		if not ignore_changed:
			node.connect("text_changed", self, "_on_field_changed")
		if init_from_prop and val:
			node.text = val
	
	if custom_update_prop:
		var custom_target_node = get_node(custom_target)
		custom_target_node.connect(custom_signal, self, "_on_field_changed")


func _on_field_changed(_new_text = "", _arg1 = "", _arg2 = ""):
	var input_node = get_node(input)
	
	var target_node = get_node(_join_np(target, prop))
	var old_val = target_node.get_indexed(prop)
	target_node.set_indexed(prop, input_node.text)
	
	emit_signal("prop_changed", input_node.text, old_val)


func _join_np(_target, _prop):
	return str(_target, ":", _prop)
