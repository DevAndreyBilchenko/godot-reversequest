extends Node
# Переключение вложенных сцен с историей
#
# Переключение, scene можно оставить пустым если нужно
# закрыть окно
# switch_to(scene, arguments = [])
#
# Перемещение назад
# back()

export(NodePath) var content_np
export(String) var group = "scene_switcher_default"

var history_size = 2
var history = []


func _ready():
	print("controller")
	_initialize_actors()


func switch_to(scene_path = "", arguments = []):
	var content = get_node(content_np)
	
	for ch in content:
		ch.queue_free()
	
	if scene_path != "":
		var scene = load(scene_path).instance()
		content.add_child(scene)
		
		history.append({
			"target": scene_path,
			"arguments": arguments
		})
		
		if history.size > history_size:
			history.pop_front()


func back():
	if history.size > 0:
		var history_item = history.pop_back()
		switch_to(history_item.target, history_item.arguments)


func _initialize_actors():
	print("call_group")
	get_tree().call_group(group, "bind_controller", self)
	
