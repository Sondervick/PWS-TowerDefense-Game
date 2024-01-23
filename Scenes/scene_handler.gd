extends Node

func _ready():
	load_main_menu()

func load_main_menu():
	#Gets the LevelSelect node, hidden in the main menu
	#Gets when the button gets pressed .pressed.connect()
	#Runs the "onLevelSelectPressed" function inside this script .connect(onLevelSelectPressed)
	get_node("MainMenu/Margin/VBC/LevelSelect").pressed.connect(onLevelSelectPressed)
	#Same idea as before.
	get_node("MainMenu/Margin/VBC/Quit").pressed.connect(onQuit)
	get_node("MainMenu/Margin/VBC/Changelog").pressed.connect(onChangelog)

func onLevelSelectPressed():
	#Get the main menu, and remove it.
	get_node("MainMenu").queue_free()
	#Will load the GameScene
	#Game scene is where all the game logic will be. All leves are instantiated in the GameScene.
	#All level specific logic will be saved in the levels themselves.
	var game_scene = load("res://Scenes/GameScene.tscn").instantiate()
	game_scene.connect("game_finished", unload_game)
	add_child(game_scene)

func onQuit():
	#quits the game
	get_tree().quit()

func onChangelog():
	#Removes the gamescene node
	get_node("MainMenu").queue_free()
	#loads the main menu
	var changelog = load("res://Scenes/UIScenes/Changelog.tscn").instantiate()
	#Adds it to the scene handler
	add_child(changelog)

func unload_game(result):
	#Removes the gamescene node
	get_node("GameScene").queue_free()
	var menu
	if(result == true):
		#Load win menu
		menu = load("res://Scenes/UIScenes/WinScreen.tscn").instantiate()
	elif(result == false):
		menu = load("res://Scenes/UIScenes/LoseScreen.tscn").instantiate()
	else:
		menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	add_child(menu)
