extends Reference

var GridStatsRoadmapItem = preload("res://addons/reversequest/edit_dialog/grid_stats_roadmap_item.gd")

var _map = []
var _step_index = 0


func add_step(type, col, row):
	var rm_item = GridStatsRoadmapItem.new()
	
	rm_item.type = type
	rm_item.col = col
	rm_item.row = row
	
	_map.append(rm_item)


func reset_progress():
	_step_index = 0


func get_next_step():
	var item = _map[_step_index]
	_step_index += 1
	return item


func get_last_step():
	return _map[_map.size()-1]
