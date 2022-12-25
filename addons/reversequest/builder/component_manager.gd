extends Reference

var ComponentType = preload("res://addons/reversequest/builder/component_type.gd")
var ComponentText: PackedScene = preload("res://addons/reversequest/builder/component_text.tscn")

func get_instance(type):
	match type:
		ComponentType.TEXT:
			return ComponentText.instance()
		
	return false
