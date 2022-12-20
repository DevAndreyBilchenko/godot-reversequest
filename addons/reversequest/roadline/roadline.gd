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
	get_node("Line2DBorder").points = wp
