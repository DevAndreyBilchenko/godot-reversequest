extends Reference


var _settings = preload("res://addons/reversequest/gd_scripts/settings.gd").new()
var _dialog_res_class = preload("res://addons/reversequest/gd_scripts/dialog_res.gd")
var _speech_res_class = preload("res://addons/reversequest/gd_scripts/speech_res.gd")
var _choice_res_class = preload("res://addons/reversequest/gd_scripts/choice_res.gd")


var _dialog
var _dialog_name
var _empty_slots = null


func load_dialog(name):
	_dialog_name = name
	_dialog = ResourceLoader.load(_get_path_to_dialog_file())


func create_dialog(name):
	_dialog_name = name
	_dialog = _dialog_res_class.new()
	create_speech()
	save()


func save():
	ResourceSaver.save(_get_path_to_dialog_file(), _dialog,  ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	

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


func create_choice(speech_code, start_text = "Новая реплика"):
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
	speech.choice_list[code] = choice
	
	return choice


func get_choice(speech_code, choice_code):
	return get_speech(speech_code).choice_list[choice_code]


func _get_next_code_index():
	var slot = _empty_slots.pop_front()
	
	if slot != null:
		return slot
		
	var size = _dialog.speech_list.size()
	
	_dialog.speech_list.resize(size+1)
	
	return size


func _get_path_to_dialog_file():
	return str(_settings.path_to_dialog_folder, "/", _dialog_name, ".res")


func _scan_empty_slots():
	_empty_slots = []
	
	for i in _dialog.speech_list.size():
		if _dialog.speech_list[i] == null:
			_empty_slots.append(i)
