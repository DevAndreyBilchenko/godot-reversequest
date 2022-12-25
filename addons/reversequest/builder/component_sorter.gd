extends Node

export(Array, NodePath) var ignore_list

var _childs

func _ready():
	var order_container = _get_order_container()
	order_container.connect("child_entered_tree", self, "_on_child_entered_tree")
	
	
func _on_child_entered_tree(node):
	var draggable = node.get_node(node.draggable_np)
	draggable.connect("gui_input", self, "_on_node_gui_input", [draggable, node])
	_setup_clean_childs()

func _on_child_exited_tree(node):
	_setup_clean_childs()

func _on_node_gui_input(event, draggable, node):
	if event is InputEventMouseMotion and event.button_mask == BUTTON_MASK_LEFT:
		draggable.rect_position += event.relative
		
		var index = node.get_index()
		var order_container = _get_order_container()
		var attempt_position = event.position + node.rect_position + draggable.rect_position
		
		var highest = {
			"test_position": Vector2.ZERO,
			"index": 0
		}
		
		for ch in _childs:
			var test_position = ch.rect_position
			
			if (attempt_position.x > test_position.x and
				attempt_position.y > test_position.y and
				attempt_position.y < test_position.y + ch.rect_size.y
				):
					highest.test_position = test_position
					highest.index = ch.get_index()
		
		if index != highest.index:
			var old_pos = draggable.rect_global_position
			order_container.move_child(node, highest.index)
			yield(get_tree(), "idle_frame")
			draggable.rect_global_position = old_pos
			
	elif (event is InputEventMouseButton and 
		event.button_index == BUTTON_LEFT and 
		event.pressed == false
		):
			draggable.rect_position = Vector2.ZERO


func _setup_clean_childs():
	var order_container = _get_order_container()
	_childs = order_container.get_children()
	
	for ignore_item in ignore_list:
		_childs.erase(get_node(ignore_item))
		

func _get_order_container():
	return get_parent()
