extends Node2D

signal plug_in

var connectivity = false

func _on_Collider_area_shape_entered(area_id, area, area_shape, self_shape):
	for i in $Collider.get_overlapping_areas():
		if i.name == 'Collider':
			connectivity = true
			emit_signal('plug_in')


func _on_Collider_area_shape_exited(area_id, area, area_shape, self_shape):
	for i in $Collider.get_overlapping_areas():
		if i.name == 'Collider':
			connectivity = false
