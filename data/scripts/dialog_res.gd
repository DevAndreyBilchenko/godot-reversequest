extends Resource
class_name DialogRes

export(Array, Resource) var speech_list = []

func find_speech(code):
	for item in speech_list:
		if item.code == code:
			return item

func find_root_speech():
	return find_speech(0)

func get_speech_count():
	return speech_list.size()
