extends Reference

var GridStatsRoadmapItem = preload("res://addons/reversequest/edit_dialog/grid_stats_roadmap_item.gd")

var _map = []
var _step_index = 0


func add_step(col = 0, row = 0, col_shift = 0, row_shift = 0, subitem = false):
	var rm_item = GridStatsRoadmapItem.new()
	
	rm_item.col = col
	rm_item.row = row
	rm_item.col_shift = col_shift
	rm_item.row_shift = row_shift
	rm_item.from_subitem = subitem
	
	_map.append(rm_item)


func reset_progress():
	_step_index = 0


func get_next_step():
	var item = _map[_step_index]
	_step_index += 1
	return item


func get_last_step():
	return _map[_map.size()-1]


func get_map():
	return _map


func display_debug():
	for item in _map:
		print(str(
			"col: ", item.col, 
			" col_shift: ", item.col_shift, 
			" row: ", item.row,
			" row_shift: ", item.row_shift,
			" from_subitem: ", item.from_subitem
		))
