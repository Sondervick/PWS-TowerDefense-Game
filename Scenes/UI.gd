extends CanvasLayer

func setTowerPreview(tower_type, mouse_pos):
	#Loads the tower scene from the given tower type
	var drag_tower = load("res://Scenes/Towers/" + tower_type + ".tscn").instantiate()
	#Rename the tower to "DragTower"
	drag_tower.set_name("DragTower")
	#Setting the color of the DragTower
	drag_tower.modulate = Color("ad54ff3c")
	
	#Define a new Sprite2D, make this the range texture
	var range_texture = Sprite2D.new()
	#math (returns a float, since there is a decimal, if that wouldn't be there, it'd return an int)
	#Refrencing the GameData (always loaded)
		#Getting the tower from the tower_data dictionary
		#Getting the range from it
	var scaling = GameData.tower_data[tower_type]["range"] / 600.0
	#We shrink our texture to the correct size
	range_texture.scale = Vector2(scaling, scaling)
	#Load the texture
	var texture = load("res://Assets/UI/Art/range_overlay.png")
	#Set the range_texture's texture to the loaded texture
	range_texture.texture = texture
	#Set the color of the range_texture to gray/blue
	range_texture.modulate = Color("00E522")
	
	#Make a new control node
	var control = Control.new()
	#Adding the drag_tower to this node, give it a readble name
	control.add_child(drag_tower, true)
	#Adding the range_texture to this node, give it a readble name
	control.add_child(range_texture, true)
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
		get_node("TowerPreview/Sprite2D").modulate = Color(color)
