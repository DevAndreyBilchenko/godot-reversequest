extends Node2D

var is_ready = false
var gap = 10
var connect_line_length = 50


func _ready():
	is_ready = true


func draw(wp: PoolVector2Array):
	if !is_ready:
		yield(self, "_ready")
	
	get_node("Line2D").points = wp


func create_waypoint(
	start_pos,
	roadline_start_col_slot_index,
	row_y_pos,
	roadline_row_slot_index,
	roadline_end_col_slot_index,
	end_pos
):
	var wp = PoolVector2Array([
		start_pos,
		start_pos + Vector2(connect_line_length, 0),
	])
	
	wp.append(wp[1] + Vector2(roadline_start_col_slot_index * (gap + 10), 0))
	wp.append(wp[2] + Vector2(0, row_y_pos))
	wp.append(wp[3] + Vector2(0, roadline_row_slot_index * (gap + 10)))
	wp.append(Vector2(end_pos.x - (roadline_end_col_slot_index * (gap + 10)), wp[4].y))
	wp.append(Vector2(wp[5].x, end_pos.y))
	wp.append(end_pos)
	
	return wp
