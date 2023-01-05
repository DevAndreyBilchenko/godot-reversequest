extends Reference

var main_parent: int = -1
var depth: int = -1
var col_index: int = -1
var connections: Array = []


func get_connections_count():
	var counter = 0
	
	for con in connections:
		if con:
			for c in con:
				if c != null:
					counter += 1
	
	return counter


func add_connection(from_item_code, from_subitem_code, roadmap):
	if from_item_code >= connections.size():
		connections.resize(from_item_code+1)
		
	var connection = connections[from_item_code]
	
	if not connection:
		connections[from_item_code] = []
		connection = connections[from_item_code]
		
	if from_subitem_code >= connection.size():
		connection.resize(from_subitem_code+1)
		
	connections[from_item_code][from_subitem_code] = roadmap
	


func get_connection_roadmap(from_item_code, from_subitem_code):
	return connections[from_item_code][from_subitem_code]
