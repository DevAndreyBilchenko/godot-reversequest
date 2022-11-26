extends Resource
class_name ChoiceRes

export(int) var code = -1
export(String) var text = ""
export(int) var link = -1

func has_link():
	return link != -1
