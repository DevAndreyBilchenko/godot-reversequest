extends Resource


export(int) var code = -1
export(int) var order = 0
export(String) var text = ""
export(int) var link = -1


func has_link():
	return link != -1


func unlink():
	link = -1
