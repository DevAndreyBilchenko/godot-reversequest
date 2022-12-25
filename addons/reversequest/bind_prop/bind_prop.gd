extends Node

export(NodePath) var take_from
export(String) var take_from_prop
export(NodePath) var set_to
export(String) var set_to_prop
export(NodePath) var wait_on
export(String) var wait_on_prop
export(String) var wait_on_signal
export(bool) var skip_initial


func _ready():
	yield(get_tree(), "idle_frame")
	
	if wait_on:
		var signal_emitter = get_node(wait_on)
		
		if wait_on_prop:
			signal_emitter = signal_emitter.get_indexed(wait_on_prop)
			
		signal_emitter.connect(wait_on_signal, self , "_on_signal_emitted")
	
	if not skip_initial:
		_on_signal_emitted()
	
	
func _on_signal_emitted():
	var take_from_node = get_node(take_from)
	var value = take_from_node.get_indexed(take_from_prop)
	var set_to_node = get_node(set_to)
	set_to_node.set_indexed(set_to_prop, value)
