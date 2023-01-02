extends Reference

func _init():
	var props = get_property_list()
	var user_fields = []
	
	for prop in props:
		if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
			user_fields.append(prop.name)
	
	for field in user_fields:
		add_user_signal(str(field, "_changed"))


func _set(property, value):
	var v = get(property)
	if v != value:
		set(property, value)
		emit_signal(str(property, "_changed"))
