extends Node2D

var mouse_in_area = false
var pressed = false
onready var plugs = get_tree().get_nodes_in_group("Connecter")


func _ready():
	for i in plugs:
		i.connect('plug_in', self, '_can_Connect')

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

func _can_Connect():
	for i in plugs:
		if i.get('connectivity'):
			print(i.name)

func _on_MouseArea_mouse_entered():
	mouse_in_area = true
	
func _on_MouseArea_mouse_exited():
	mouse_in_area = false
