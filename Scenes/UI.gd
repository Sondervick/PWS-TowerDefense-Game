extends CanvasLayer

func setTowerPreview(tower_type, mouse_pos):
	#Loads the tower scene from the given tower type
	var drag_tower = load("res://Scenes/Towers/" + tower_type + ".tscn").instantiate()
	#Rename the tower to "DragTower"
	drag_tower.set_name("DragTower")
	#Setting the color of the DragTower
	drag_tower.modulate = Color("ad54ff3c")
	
	#Make a new control node
	var control = Control.new()
	#Adding the drag_tower to this node, give it a readble name
	control.add_child(drag_tower, true)
	#Setting the rectangle position to the mouse position
	control.position = mouse_pos
	#Changing the control node's name to "TowerPreview"
	control.set_name("TowerPreview")
	#Add the control node to the object (UI), give it a readble name
	add_child(control, true)
	#Moves the "TowerPreview" control node to the object in the tree
	move_child(get_node("TowerPreview"), 0)

func updateTowerPreview(new_pos, color):
	#Getting the TowerPreview node, setting the position to the new position
	get_node("TowerPreview").position = new_pos
	#If the DragTower node's color is not equal to the given color
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		#Set the DragTower color to the given color
		get_node("TowerPreview/DragTower").modulate = Color(color)
