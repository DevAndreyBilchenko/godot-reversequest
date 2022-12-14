extends Control

export(NodePath) var target_np

var choice = preload("res://addons/reversequest/choice/choice.gd")


func _ready():
	add_to_group(choice.GROUP_ZONE)


func _on_click():
	get_tree().call_group(choice.GROUP_REQUESTER, "link_to", get_node(target_np).res)
