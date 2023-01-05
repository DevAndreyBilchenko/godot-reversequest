extends Reference

func _init():
	var props = get_property_list()
	
	for prop in props:
		if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			add_user_signal(str(prop.name.trim_prefix("_"), "_changed"))


func _get(property):
	return get(str("_", property))


func _set(property, value):
	var hidden_prop = str("_", property)
	var v = get(hidden_prop)

	if v != value:
		set(hidden_prop, value)
		emit_signal(str(property, "_changed"))
	
	return true
