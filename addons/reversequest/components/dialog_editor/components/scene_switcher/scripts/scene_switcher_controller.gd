extends Node
# Переключение вложенных сцен с историей
#
# Переключение, scene можно оставить пустым если нужно
# закрыть окно
# switch_to(scene, send_data = [])
#
# Перемещение назад
# back()

export(NodePath) var content_np
export(String) var group = "scene_switcher_default"

var history_size = 2
var history = []


func _ready():
	_initialize_actors()


func switch_to(scene_path = "", send_data = []):
	var content = get_node(content_np)
	var saved_instance_path = ""
	var saved_send_data = []
	
	for ch in content.get_children():
		var store = ch.get_node_or_null("SceneSwitcherStore")
		
		if store != null:
			saved_instance_path = store.scene_instance
			saved_send_data = store.send_data
		
		ch.queue_free()
	
	if saved_instance_path != "":
		history.append({
			"target": saved_instance_path,
			"send_data": saved_send_data
		})
	
	if scene_path != "":
		var scene = load(scene_path).instance()
		
		var store = scene.get_node_or_null("SceneSwitcherStore")
		if store:
			store.send_data = send_data
		
		content.add_child(scene)
		
		if history.size() > history_size:
			history.pop_front()
			
		call_deferred("_initialize_actors")


func back():
	if history.size() > 0:
		var history_item = history.pop_back()
		switch_to(history_item.target, history_item.send_data)


func _initialize_actors():
	get_tree().call_group(group, "bind_controller", self)
	
