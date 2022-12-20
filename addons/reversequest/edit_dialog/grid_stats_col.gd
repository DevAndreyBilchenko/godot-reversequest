extends Reference


var items_count: int = -1
var out_count: int = -1
var in_count: int = -1
var max_real_width: int = 0


func add_empty_out(n):
	out_count += n


func get_next_out(shift = 1):
	var next_slot = out_count + shift
	
	if next_slot > out_count:
		out_count = next_slot
	
	return next_slot
	
	
func get_next_in():
	in_count += 1
	return in_count


func get_out_roadlines_count():
	return out_count + 1
	

func get_in_roadlines_count():
	return in_count + 1
