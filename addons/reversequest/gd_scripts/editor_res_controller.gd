extends Reference

var settings = preload("res://addons/reversequest/gd_scripts/settings.gd").new()
var editor_resource


func _init():
	var loaded = ResourceLoader.load(settings.path_to_editor_specific, "", true)
	
	if loaded == null:
		editor_resource = preload("res://addons/reversequest/gd_scripts/editor_res.gd").new()
	else:
		editor_resource = loaded


func get_resource():
	return editor_resource


func add_dialog_item(editor_label, file_name):
	var dialog_item = preload("res://addons/reversequest/gd_scripts/dialog_editor_item_res.gd").new()
	dialog_item.display_name = editor_label
	dialog_item.file_name = file_name
	
	editor_resource.dialog_list.append(dialog_item)
	save()
	

func get_dialog_list():
	return editor_resource.dialog_list


func save():
	ResourceSaver.save(settings.path_to_editor_specific, editor_resource)
