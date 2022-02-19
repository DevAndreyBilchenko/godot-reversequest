extends Node2D

onready var areas = [$Place, $Place2, $Place3, $Place4]

var clothes_names = ['cloth','item']

var opened = false
var opening = false
var step = 1000

onready var start_x = self.position.x
onready var start_y = self.position.y

func move_to_place(overlapping_area, clothes, move_to):
	for _i in overlapping_area:
		if _i.get_children()[0].name == clothes:
#			_i.get_parent().get_parent().in_place = true
			_i.get_parent().get_parent().position = self.position + move_to.position


func animation(delta):
	if opened:
		if self.position >= Vector2(self.position.x, 410):
			self.position -= Vector2(0, step * delta)
	else:
		if self.position <= Vector2(self.position.x, start_y):
			self.position += Vector2(0, step * delta)


func _process(delta):
	
	animation(delta)
	
	for _i in areas:
		
		var move_to = _i.get_node("ConnectArea")
		if !opening:
			if _i == areas[0] or _i == areas[1]:
				move_to_place(_i.get_overlapping_areas(), clothes_names[0], move_to)
			elif _i == areas[2] or _i == areas[3]:
				move_to_place(_i.get_overlapping_areas(), clothes_names[1], move_to)


func _on_TextureButton_pressed():
	if not opened:
			opened = true
	else:
		opened = false
