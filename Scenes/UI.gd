extends CanvasLayer

func _ready():
	auto_price()

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
	
	if get_node("TowerPreview").position == null:
		get_parent().cancelBuildMode()
		return
	
	get_node("TowerPreview").position = new_pos
	#If the DragTower node's color is not equal to the given color
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		#Set the DragTower color to the given color
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite2D").modulate = Color(color)

func update_health(health):
	get_node("HUD/InfoBar/HBoxContainer/Lives").set_text(str(health))

func update_money(money):
		get_node("HUD/InfoBar/HBoxContainer/Money").set_text(str(money))

#
# Game Control function
#

func _on_pause_play_pressed():
	#If build mode is enabled
	if get_parent().build_mode:
		#cancel build mode.
		get_parent().cancelBuildMode()
	
	#Getting wether the game is paused
	if get_tree().is_paused():
		#If it is, unpause
		get_tree().paused = false
		get_node("HUD/GameControls/PausePlay").button_pressed = true
	#If the current wave is 0, aka no waves have started yet
	elif get_parent().current_wave == 0:
		#Add 1 to the wave counter
		get_parent().current_wave =+ 1
		#Start new wave
		get_parent().start_next_wave()
		get_node("HUD/GameControls/PausePlay").button_pressed = true
	else:
		#If it isn't, pause
		#load pause menu
		var pause_menu = load("res://Scenes/UIScenes/PauseMenu.tscn").instantiate()
		add_child(pause_menu, true)
		get_tree().paused = true
		get_node("HUD/GameControls/PausePlay").button_pressed = false


func _on_speed_up_pressed():
	#If build mode is enabled
	if get_parent().build_mode:
		#cancel build mode.
		get_parent().cancelBuildMode()
	
	#If the game speed is 200%
	if Engine.get_time_scale() == 2.0:
		#Set game speed back to original (100%)
		Engine.set_time_scale(1.0)
	else:
		#Speed up the game to 200%
		Engine.set_time_scale(2.0)

#
# UI ELEMENTS
#

func auto_price():
	get_node("HUD/BuildMenu/Gun1Price").set_text(" €" + str(GameData.tower_data["gun_tier_1"]["costs"]))
	get_node("HUD/BuildMenu/Gun2Price").set_text(" €" + str(GameData.tower_data["missile_tier_1"]["costs"]))
