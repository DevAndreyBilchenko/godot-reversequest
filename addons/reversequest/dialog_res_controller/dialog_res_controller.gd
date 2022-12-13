extends Node


signal structure_update
signal cosmetic_update


var _settings = preload("res://addons/reversequest/gd_scripts/settings.gd").new()
var _dialog_res_class = preload("res://addons/reversequest/gd_scripts/dialog_res.gd")
var _speech_res_class = preload("res://addons/reversequest/gd_scripts/speech_res.gd")
var _choice_res_class = preload("res://addons/reversequest/gd_scripts/choice_res.gd")


var _dialog
var _dialog_name
var _empty_slots = null


#----------------------------
# DIALOG CONTROL FUNCTIONS
# ---------------------------

func load_dialog(name):
	_dialog_name = name
	_dialog = ResourceLoader.load(_get_path_to_dialog_file())
	return _dialog


func get_saved_dialogs():
	var dir = Directory.new()
	var files = []
	if dir.open(_settings.path_to_dialog_folder) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return files


func remove_saved_dialog(file_name):
	var dir = Directory.new()
	var _err = dir.remove(_create_path_to_dialog_file(file_name))


func rename_saved_dialog(new_name):
	var old_name = _dialog_name
	_dialog_name = new_name
	save()
	remove_saved_dialog(old_name)


func exists_saved_dialog(file_name):
	var dir = Directory.new()
	return dir.file_exists(_create_path_to_dialog_file(file_name))


func create_dialog(name, autosave = false):
	_dialog_name = name
	_dialog = _dialog_res_class.new()
	create_speech()
	
	if autosave:
		save()
		
	return _dialog


func save(new_name = ""):
	if new_name != "":
		_dialog_name = new_name
	
	ResourceSaver.save(_get_path_to_dialog_file(), _dialog,  ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)

#----------------------------
# SPEECH CONTROL FUNCTIONS
# ---------------------------

func create_speech(start_text = "Новая реплика", choice_list = []):
	var speech = _speech_res_class.new()
	speech.code = _get_next_code_index()
	speech.text = start_text
	speech.choice_list = choice_list
	
	_dialog.speech_list[speech.code] = speech
	
	return speech


func get_speech(code):
	if _dialog.speech_list.size() > code:
		return _dialog.speech_list[code]
	else:
		return null


func get_speech_list():
	return _dialog.speech_list


#----------------------------
# CHOICE CONTROL FUNCTIONS
# ---------------------------

func create_choice(speech_code, start_text = "Новый выбор"):
	var choice = _choice_res_class.new()
	var speech = get_speech(speech_code)
	var size = speech.choice_list.size()
	var code = -1
	
	for i in size:
		if speech.choice_list[i] == null:
			code = i
			break
			
	if choice.code == -1:
		speech.choice_list.resize(size+1)
		code = size
	
	choice.code = code
	choice.text = start_text
	choice.order = code
	speech.choice_list[code] = choice
	
	return choice


func get_choice(speech_code, choice_code):
	return get_speech(speech_code).choice_list[choice_code]


func emit_structure_update():
	emit_signal("structure_update")


func emit_cosmetic_update():
	emit_signal("cosmetic_update")


func _get_next_code_index():
	if _empty_slots != null:
		var slot = _empty_slots.pop_front()
		
		if slot != null:
			return slot
		
	var size = _dialog.speech_list.size()
	
	_dialog.speech_list.resize(size+1)
	
	return size


func _get_path_to_dialog_file():
	return _create_path_to_dialog_file(_dialog_name)


func _create_path_to_dialog_file(file_name: String):
	var end = ".res"
	if file_name.ends_with(".res"):
		end = ""

	return str(_settings.path_to_dialog_folder, "/", file_name, end)


func _scan_empty_slots():
	_empty_slots = []
	
	for i in _dialog.speech_list.size():
		if _dialog.speech_list[i] == null:
			_empty_slots.append(i)
