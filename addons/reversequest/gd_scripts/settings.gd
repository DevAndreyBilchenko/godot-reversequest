extends Reference

const path_to_settings_resource = "res://addons/reversequest/tmp/settings.res"
var _settings = null
var path_to_dialog_folder setget , _get_path_to_dialog_folder
var path_to_editor_specific setget , _get_path_to_editor_specific


func _init():
	if ResourceLoader.exists(path_to_settings_resource):
		_settings = ResourceLoader.load(path_to_settings_resource)
	

func _get_path_to_dialog_folder():
	return _settings_get("path_to_dialog_folder", "res://data/dialogs")

func _get_path_to_editor_specific():
	return _settings_get("path_to_editor_specific", "res://addons/reversequest/tmp/editor_specific.res")


func _settings_get(key, default):
	if _settings == null:
		return default
	
	return _settings.get(key)
