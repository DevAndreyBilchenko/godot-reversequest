extends Reference

var max_choice_count: int = 0
var max_real_height: float = 0
var roadline_count: int = -1


func get_next_roadline():
	roadline_count += 1
	return roadline_count


func get_roadlines_count():
	return roadline_count + 1
