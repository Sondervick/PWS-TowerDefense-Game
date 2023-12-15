extends Node2D

signal game_finished(result)

# Creating various variables
var map_node

var build_mode = false
var build_valid = false
var build_location
var build_type

var base_health = 200
var start_money = 300

var current_wave = 0
var enemies_in_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Gets all the buttons in the "build_buttons" group.
	for i in get_tree().get_nodes_in_group("build_buttons"):
		#Connects the button to the initiateBuildMode script which requires a tower type.
		#i.get_name() gets the name of the node object. (example: Gun, Missile)
		i.pressed.connect(initiateBuildMode.bind(i.name))
	
	#Gets the Normal1 node, hidden in the Level Select menu
	#Gets when the button gets pressed .pressed.connect()
	#Runs the "onLevelOneNormal" function inside this script .connect(onLevelSelectPressed)
	get_node("UI/LevelSelect/Margin/Level1VBC/Normal1").pressed.connect(onLevelNormal.bind(1))
	get_node("UI/LevelSelect/Margin/Level1VBC/Aim1").pressed.connect(onLevelAim.bind(1))
	get_node("UI/LevelSelect/Margin/Level2VBC/Normal2").pressed.connect(onLevelNormal.bind(2))
	get_node("UI/LevelSelect/Margin/Level2VBC/Aim2").pressed.connect(onLevelAim.bind(2))
	get_node("UI/LevelSelect/Margin/Level1VBC/Back").pressed.connect(onBack)
	
	GameData.money = start_money
	get_node("UI").update_money(start_money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#If build_mode is set to true
	if build_mode:
		#Run updateTowerPreview func
		updateTowerPreview()

#Only runs when any input given is not already being consumed by the UI
func _unhandled_input(event):
	#If the event is the ui_canceled and we're in build_mode
	if event.is_action_released("ui_cancel") and build_mode == true:
		#cancel the build mode
		cancelBuildMode()
	elif event.is_action_released("ui_cancel") and build_mode == false:
		get_node("UI")._on_pause_play_pressed()
	
	#If the event is the ui_accept and we're in build_mode
	if event.is_action_released("ui_accept") and build_mode == true:
		#We verify and build the tower
		verifyAndBuild()
		#Then cancel the build mode after we're done
		cancelBuildMode()

#
# Tower Building Scripts
#

func initiateBuildMode(tower_type):
	#If the user is already in build mode
	if build_mode:
		#Cancel it, you cant be in build mode multiple times
		cancelBuildMode()
	
	#Sets the build_type variable to the tower_type, and appends "_tier_1"
	#You always build a tier 1 tower, so you can append this
	build_type = tower_type + "_tier_1"
	
	#Sets build mode to true (crazy ikr)
	build_mode = true
	#Getting the UI, runs the function setTowerPreview under that node.
	#Sends the build_type & the mouse position to that function
	get_node("UI").setTowerPreview(build_type, get_global_mouse_position())

func updateTowerPreview():
	#Save the mouse position
	var mouse_position = get_global_mouse_position()
	#Get the current tile from the TowerExclusion tilemap in map_node (example: Map1)
	#world_to_map wile return the tile coordinate where the mouse currently is
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	#We're getting the tile position (coordinate) from that tile.
	#+ Offesetting the tower by 32x32px, else the placing looks goofy.
	var tile_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	#check if there is any asset in the tileset where you will build
	var existing_object = map_node.get_node("TowerExclusion").get_cell_source_id(0, current_tile)
	
	#If there isn't a tile loaded
	if existing_object == -1:
		#Running the updateTowerPreview in the UI script
		#Adding the tile position and green color.
		get_node("UI").updateTowerPreview(tile_position, "00E522")
		
		#Setting the build_valid to true
		build_valid = true
		#Build location will be the location where the tile should be placed
		build_location = tile_position
	else:
		#Running the upateTowerPreview in the UI script
		#Adding the tile position and a red color
		get_node("UI").updateTowerPreview(tile_position, "E80000")
		#When there is an object in that tile, set build_valid to false
		build_valid = false
	
	#Gets every existing tower from the node "Towers" in the current map
	var existing_towers = map_node.get_node("Towers").get_children()
	#For every of these towers
	for c in existing_towers:
		#Check if the current position is equal to the build_location
		if c.position == build_location:
			#If so, build is invalid, and update the tower previeew in the UI script
			get_node("UI").updateTowerPreview(tile_position, "E80000")
			#Set build to invalid
			build_valid = false
			#Stop while loop
			break
	

func cancelBuildMode():
	#Resetting the variables
	build_mode = false
	build_valid = true
	#Then remove TowerPreview node
	#free() will delete it on this frame
	get_node("UI/TowerPreview").free()

func cancelBuildModeFree():
	#Resetting the variables
	build_mode = false
	build_valid = true
	#Then remove TowerPreview node
	#queue_free() will delete it on the next available frame.
	get_node("UI/TowerPreview").queue_free()

func verifyAndBuild():
	#If the build is on a valid place
	if build_valid:
		#Get the tower costs
		var tower_costs = int(GameData.tower_data[build_type]["costs"])
		var money = int(GameData.money)
		#If the money is less than the tower costs
		if money < tower_costs:
			cancelBuildModeFree()
			#Return so it doesn't execute more of the script
			return
		#Set the money equal to itself - the tower cost
		money -= tower_costs
		GameData.money = money
		#Run the "set_money" func in the UI script
		get_node("UI").update_money(money)
		
		#Load the tower as a scene object
		var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate()
		#Set the location of this tower to the build location
		new_tower.position = build_location
		new_tower.type = build_type
		new_tower.category = GameData.tower_data[build_type]["fire-catagory"]
		new_tower.built = true;
		#Add it as a child to the Towers node and give it a readable name.
		map_node.get_node("Towers").add_child(new_tower, true)

# 
# Wave Functions
# 

func start_next_wave():
	# Getting the wave data
	var wave_data = retrieve_wave_data()
	# Yielding the code (stopping it) for 2 seconds
	# This prevents waves from spawning instantly after each other.
	await(get_tree().create_timer(2)).timeout
	spawn_enemies(wave_data)

func retrieve_wave_data():
	# Hard coding the wave data, nesting 2 arrays
	# First is the enemy type, second is the time between spawns
	var wave_data = [["EnemySexyMf", 0.7], ["GreenTree", 0.3], ["OrangeTree", 0.4], [getRandomEnemy(), 0.2], [getRandomEnemy(), 0.1]]
	current_wave += 1
	# Getting the amount of enemies per wave, this is done by looking at the array size
	enemies_in_wave = wave_data.size()
	GameData.enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	# For every entry (i) in wave_data
	for i in wave_data:
		# Load a new enemy scene from the Scenes/Enemies folder
		# Get the name of the enemy from the Array (the name of the enemy is at place 0 in the array)
		# Add the .tscn file extension
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		new_enemy.connect("base_damage", on_base_damage)
		# Add the new_enemy to the Path as a child, 
		# also give it a human readable name (true).
		map_node.get_node("Path").add_child(new_enemy, true)
		# Wait the amount of seconds between spawning another enemy.
		# Wait time is defined in the second argument of the array i[1], not i[2]!!
		await(get_tree().create_timer(i[1])).timeout
		

func on_base_damage(damage):
	#Set the health equal to itself - the damage
	base_health -= damage
	#If it's lower or equal than 0
	if base_health <= 0:
		#Emit loss signal
		emit_signal("game_finished", false)
	else:
		#Update health bar
		get_node("UI").update_health(base_health)

func getRandomEnemy():
	#Make a random int (whole number) between 1 and 3
	var randomTower = randi_range(1,3)
	#Initializing the tower name variable
	var towerName = null
	
	#If... then name...
	if randomTower == 1:
		towerName = "OrangeTree"
	if randomTower == 2:
		towerName = "GreenTree"
	if randomTower == 3:
		towerName = "EnemySexyMf"
	return towerName

#
# Level Selection Things
#

func onLevelNormal(map_num):
	#Set the UI layer to visible
	get_node("UI/HUD").visible = true
	#Removing the level select scene instance
	get_node("UI/LevelSelect").queue_free()
	GameData.game_mode = "normal"
	var map = load("res://Scenes/Maps/Map" + str(map_num) + ".tscn").instantiate()
	# Add the new_enemy to the Path as a child, 
	# also give it a human readable name (true).
	add_child(map, true)
	#Setting the map node to the map that'll be loaded
	map_node = get_node("Map" + str(map_num))
	GameData.map_node = map_node

func onLevelAim(map_num):
	#Set the UI layer to visible
	get_node("UI/HUD").visible = true
	#Removing the level select scene instance
	get_node("UI/LevelSelect").queue_free()
	GameData.game_mode = "manual_aim"
	var map = load("res://Scenes/Maps/Map" + str(map_num) + ".tscn").instantiate()
	# Add the new_enemy to the Path as a child, 
	# also give it a human readable name (true).
	add_child(map, true)
	#Setting the map node to the map that'll be loaded
	map_node = get_node("Map" + str(map_num))
	GameData.map_node = map_node

func onBack():
	#Reloads the current scene, this means it'll reset to the main_menu
	get_tree().reload_current_scene()
