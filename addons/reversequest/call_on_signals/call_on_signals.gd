extends Node

export(NodePath) var call_node
export(String) var call_prop
export(String) var method_name
export(bool) var deffered = true
export(bool) var call_once = true

var _emitting = false


func _on_signal_emit(_arg1 = false, _arg2 = false, _arg3 = false, _arg4 = false):
	if call_once:
		if _emitting:
			return
		else:
			_emitting = true
	
	var node = get_node(call_node)
	var callable = node
	
	if call_prop:
		callable = node.get_indexed(call_prop)
		
	if deffered:
		callable.call_deferred(method_name)
	else:
		callable.call(method_name)
