extends Node2D

var randint

func _ready():
	var clothes_names = ['cloth','item']
	
	var clothes = preload("res://components/backpack_minigame/components/stuff/scenes/clothes.tscn")
	
	for _i in range(len(clothes_names)):
		var cloth = clothes.instance()
		
		randint = randi()%2
		
		add_child(cloth)
		
		cloth.set_name(clothes_names[randint])
		
		cloth.rotation += _i
		
		cloth.position += Vector2(-300, -180 + 150 * _i)
