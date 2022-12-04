extends Reference


var items_count: int = 0
var out_count: int = -1
var in_count: int = -1


func get_next_out():
	out_count += 1
	return out_count
	
	
func get_next_in():
	in_count += 1
	return in_count
