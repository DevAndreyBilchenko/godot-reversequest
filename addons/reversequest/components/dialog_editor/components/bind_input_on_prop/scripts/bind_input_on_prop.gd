extends Node

export(NodePath) var input
export(NodePath) var target
export(String) var prop
export(bool) var init_from_prop = true


func _ready():
	yield(get_tree(), "idle_frame")
	_setup()
	
	
func _setup():
	var node = get_node(input)
	var val = ""
	
	if init_from_prop:
		var n = get_node(_join_np(target, prop))
		val = n.get_indexed(prop)
	
	if node is LineEdit:
		node.connect("text_changed", self, "_on_field_changed")
		if init_from_prop and val:
			node.text = val


func _on_field_changed(_new_text):
	var input_node = get_node(input)
	
	var target_node = get_node(_join_np(target, prop))
	target_node.set_indexed(prop, input_node.text)


func _join_np(_target, _prop):
	return str(_target, ":", _prop)
