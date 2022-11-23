extends Node2D

var is_ready = false
var gap = 10
var connect_line_length = 50
var x_gap
var y_gap
var speech_size_x

func _ready():
	is_ready = true

func setup(_x_gap, _y_gap, _speech_size_x):
	x_gap = _x_gap
	y_gap = _y_gap
	speech_size_x  = _speech_size_x

func draw(from, to, _speech_node_list):
	if !is_ready:
		yield(self, "_ready")
	
	var line = PoolVector2Array([Vector2.ZERO, Vector2(connect_line_length, 0)])
	
	if from.is_in_group("choice"):
		position = Vector2(from.global_position.x + from.size_x + gap, from.global_position.y + from.size_y / 2 )
	
	var direction_x = to.global_position.x - from.global_position.x
	var move_cycle = floor(direction_x / (y_gap + speech_size_x));
	
	$Debug/Cycle.text = str(move_cycle)
	
	var cycle = 1
	while cycle <= move_cycle:
		
		cycle += 1
		pass
	
	# Финальное подключение
	line.append( ( to.global_position - global_position ) + Vector2(-(connect_line_length + gap), to.base_y / 2) )
	line.append( ( to.global_position - global_position ) + Vector2(-gap, to.base_y / 2) )
	
	get_node("Line2D").points = line

func get_closest_shift_point(_pos, _direction_x, _speech_node_list):
	pass
