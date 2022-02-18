extends Node2D

var editor_path = "res://data/dialogs/0_editor.res";

func _on_New_pressed():
	$ScreenContainer/CenterContainer.hide();
	$ScreenContainer/EnterName.show();

func _on_Open_pressed():
	$ScreenContainer/CenterContainer.hide();
	
	var card_scene = preload("res://components/dialog_editor/components/card/scenes/card.tscn")
	var editor_resource = ResourceLoader.load(editor_path)
	var container = $ScreenContainer/ScrollContainer/DialogsList;
	
	for n in container.get_children():
		n.queue_free()
	
	for item in editor_resource.list:
		var card_item = card_scene.instance();
		card_item.set_data(item.display_name, item.file_name)
		card_item.connect("open", self, "_on_Card_open")
		container.add_child(card_item)
	
	$ScreenContainer/ScrollContainer.show()

func _on_CreateButton_pressed():
	var DialogResEditorItem = preload("res://data/scripts/dialog_editor_item_res.gd")
	var DialogRes = preload("res://data/scripts/dialog_res.gd")
	var dr = DialogRes.new()
	var editorResource = ResourceLoader.load(editor_path)
	var item = DialogResEditorItem.new()
	
	item.display_name = $ScreenContainer/EnterName/EditorNameLineEdit.text
	item.file_name = $ScreenContainer/EnterName/NameLineEdit.text

	
	editorResource.list.append(item)
	
	if ResourceSaver.save(str("res://data/dialogs/", item.file_name, ".res"), dr) != OK:
			return
		
	if ResourceSaver.save(editor_path, editorResource) != OK:
			return
	
	# Show editor with opened resource

func _on_Card_open(id):
	print(str("open id: ", id))
	# Show editor with opened resource
	pass
