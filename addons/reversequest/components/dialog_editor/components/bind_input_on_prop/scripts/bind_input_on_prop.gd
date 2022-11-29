extends Node

export(NodePath) var input
export(NodePath) var target
export(String) var prop
export(bool) var init_from_prop = true


func _ready():
	call_deferred("_setup")
	
	
func _setup():
	var node = get_node(input)
	var val = ""
	
	if init_from_prop:
		val = get_indexed(_join_np(target, prop))
	
	if node is LineEdit:
		node.connect("text_changed", self, "_on_field_changed")
		if init_from_prop:
			node.text = val


func _on_field_changed():
	var node = get_node(input)
	
	set_indexed(_join_np(target, prop), node.text)


func _join_np(target, prop):
	return str(target, ":", prop)
