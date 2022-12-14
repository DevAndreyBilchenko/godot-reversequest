extends Reference


var items_count: int = -1
var out_count: int = -1
var in_count: int = -1
var max_real_width: int = 0


func get_next_out():
	out_count += 1
	return out_count
	
	
func get_next_in():
	in_count += 1
	return in_count


func get_out_roadlines_count():
	return out_count + 1
	

func get_in_roadlines_count():
	return in_count + 1
