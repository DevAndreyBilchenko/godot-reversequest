extends HFlowContainer

export(PackedScene) var Holder

var component_manager = preload("res://addons/reversequest/builder/component_manager.gd").new()
var value setget _set_value, _get_value

onready var _menu_button = $MenuButton
onready var _sorter = $ComponentSorter

func _ready():
	_menu_button.get_popup().connect("id_pressed", self, "_on_menu_component_pick")


func _on_menu_component_pick(type):
	var component = component_manager.get_instance(type)
	
	if component != null:
		_create_new_holder_from_component(component)


func _get_value():
	var value = []
	
	var childs = _sorter._childs
	for holder in childs:
		value.append(holder.value)
	
	return value


func _set_value(v):
	for component_value in v:
		var component = component_manager.get_instance(component_value.type)
		
		if component != null:
			component.value = component_value
			_create_new_holder_from_component(component)


func _create_new_holder_from_component(component):
	var holder = Holder.instance()
	holder.add_component(component)
	add_child_below_node(get_child(0), holder)
