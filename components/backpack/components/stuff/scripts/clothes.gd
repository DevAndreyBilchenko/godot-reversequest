extends Node2D

#var in_place = false
var pressed = false
var mouse_in_area = false

func _input(event):
	if mouse_in_area:
		if event is InputEventMouseButton and event.button_index == 1:
			if !pressed:
				pressed = true
				self.z_index += 1
			else:
				pressed = false
				self.z_index -= 1

		if event is InputEventMouseMotion:
			if pressed:
				self.position = event.position
			else:
				pass

func set_name(name):
	get_node("Sprite/ConnectArea/CollisionShape2D").name = name

func _on_MouseArea_mouse_entered():
	mouse_in_area = true

func _on_MouseArea_mouse_exited():
	mouse_in_area = false
