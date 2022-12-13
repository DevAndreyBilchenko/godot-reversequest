extends Control

var choice = preload("res://addons/reversequest/choice/choice.gd")


func _ready():
	add_to_group(choice.GROUP_ZONE)


func _on_click():
	get_tree().call_group(choice.GROUP_REQUESTER, "link_to", get_parent().res)
