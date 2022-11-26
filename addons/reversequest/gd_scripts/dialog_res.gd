extends Resource


export(Array, Resource) var speech_list = []


func find_speech(code):
	for item in speech_list:
		if item.code == code:
			return item


func find_root_speech():
	return find_speech(0)


func get_speech_count():
	return speech_list.size()


#func create_root_speech():
#	var root_speech = speech_res_class.new()
#	root_speech.code = 0
#	root_speech.text = "Корневая реплика"
#	root_speech.choice_list = []
#	dialog.speech_list.append(root_speech)
#
#
#func create_speech():
#	var speech = speech_res_class.new()
#	speech.code = get_next_code_index(dialog.speech_list)
#	speech.text = "Новая реплика"
#	speech.choice_list = []
#	return speech


func get_next_code_index(list):
	var code = -1

	if list != null:
		for item in list:
			if item.code > code:
				code = item.code

	return code + 1
