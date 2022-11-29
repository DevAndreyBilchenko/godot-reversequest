extends Reference

var settings = preload("res://addons/reversequest/gd_scripts/settings.gd").new()
var editor_resource


func _init():
	var loaded = ResourceLoader.load(settings.path_to_editor_specific, "", true)
	
	if loaded == null:
		editor_resource = preload("res://addons/reversequest/gd_scripts/editor_res.gd").new()
		save()
	else:
		editor_resource = loaded


func get_resource():
	return editor_resource


func add_dialog_item(editor_label, file_name):
	var dialog_item = preload("res://addons/reversequest/gd_scripts/editor_meta_dialog_res.gd").new()
	dialog_item.code = hash(_get_dialog_code(file_name))
	dialog_item.display_name = editor_label
	dialog_item.file_name = file_name
	
	add_res_meta(dialog_item)
	save()
	return dialog_item


func get_dialog_item(file_name):
	return get_res_meta(_get_dialog_code(file_name))


func remove_dialog_item(file_name):
	remove_res_meta(_get_dialog_code(file_name))


func get_dialog_list():
	return editor_resource.dialog_list


func add_res_meta(meta_item):
	editor_resource.meta.append(meta_item)
	editor_resource.meta.sort_custom(self, "_bcompare_meta")
	save()


func get_res_meta(code):
	var meta_index = _get_res_meta_index(code)
	
	if meta_index + 1 > editor_resource.meta.size():
		return null
	
	if editor_resource.meta[meta_index].code != code:
		return null
	
	return editor_resource.meta[meta_index]


func remove_res_meta(code):
	var meta_index = _get_res_meta_index(code)
	
	if meta_index + 1 > editor_resource.meta.size():
		return null
	
	if editor_resource[meta_index].code != code:
		return null
		
	editor_resource.meta.remove(meta_index)


func save():
	ResourceSaver.save(settings.path_to_editor_specific, editor_resource)


func _bcompare_meta(a, b):
	var _a = a if typeof(a) == TYPE_INT else a.code
	var _b = b if typeof(b) == TYPE_INT else b.code
	
	return _a < _b


func _get_dialog_code(file_name):
	return hash(str("dialog_", file_name))


func _get_res_meta_index(code):
	return editor_resource.meta.bsearch_custom(code, self, "_bcompare_meta")
