extends Node2D

var is_ready = false
var gap = 10
var connect_line_length = 50
var choice

func _ready():
	is_ready = true
	choice.connect("tree_exited", self, "_on_choice_tree_exited")
	choice.state_list.connect("link_changed", self, "_on_state_list_link_changed")


func draw(wp: PoolVector2Array):
	if !is_ready:
		yield(self, "_ready")
	
	get_node("Line2D").points = wp
	get_node("Line2DBorder").points = wp


func _on_choice_tree_exited():
	queue_free()


func _on_state_list_link_changed():
	if choice.state_list.link == choice.state_list.LINK_UNLINKED:
		queue_free()
