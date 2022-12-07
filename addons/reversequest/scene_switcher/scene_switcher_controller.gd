extends Node
# Переключение вложенных сцен
#
# Переключение, scene можно оставить пустым если нужно
# закрыть окно
# switch_to(scene, send_data = [])

export(NodePath) var content_np
export(String) var group = "scene_switcher_default"


func _ready():
	add_to_group(group)


func switch_to(scene_path = "", send_data = []):
	var content = get_node(content_np)
	
	for ch in content.get_children():
		ch.queue_free()
	
	if scene_path != "":
		var scene = load(scene_path).instance()
		
		var store = scene.get_node_or_null("SceneSwitcherStore")
		if store:
			store.send_data = send_data
		
		content.add_child(scene)
