extends Control

onready var grid_node = $LayoutStandard/ScrollContainer/VboxContainer/MarginContainer/GridContainer


func add_item(item):
	grid_node.add_child(item)


func remove_item(item):
	grid_node.remove_child(item)
