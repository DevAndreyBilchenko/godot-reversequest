extends Control

const BASE_HEIGHT = 40

export(NodePath) var content_np
export(NodePath) var draggable_np

var _component_node

func add_component(component_node):
	_component_node = component_node
	_component_node.get_size_limit = funcref(self, "_get_size_limit")
	_component_node.connect("new_size", self, "_on_component_new_size")
	
	var content = get_node(content_np)
	
	content.add_child(_component_node)


func _get_size_limit():
	return get_parent().rect_size - (rect_size - get_node(content_np).rect_size)


func _on_component_new_size(size):
	var ns = size + (rect_size - get_node(content_np).rect_size)
	
	if ns.y < BASE_HEIGHT:
		ns.y = BASE_HEIGHT
	else:
		ns.y = ceil(ns.y / BASE_HEIGHT) * BASE_HEIGHT
	
	
	rect_min_size = ns
	rect_size = ns
