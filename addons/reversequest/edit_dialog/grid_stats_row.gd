extends Reference

var max_choice_count: int = 0
var roadline_count: int = -1


func get_next_roadline():
	roadline_count += 1
	return roadline_count
