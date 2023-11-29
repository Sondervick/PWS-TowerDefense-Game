extends Node

func _ready():
	#Gets the LevelSelect node, hidden in the main menu
	#Gets when the button gets pressed .connect("pressed", ..)
	#Sets the code to execute to this secript .connect("pressed", self, ...)
	#Runs the "onLevelSelectPressed" function inside this script .connect("pressed", self, "onLevelSelectPressed")
	get_node("MainMenu/Margin/VBC/LevelSelect").pressed.connect(onLevelSelectPressed)
	#Same idea as before.
	get_node("MainMenu/Margin/VBC/Quit").pressed.connect(onQuit)

func onLevelSelectPressed():
	#Get the main menu, and remove it.
	get_node("MainMenu").queue_free()
	#Will load the GameScene
	#Game scene is where all the game logic will be. All leves are instantiated in the GameScene.
	#All level specific logic will be saved in the levels themselves.
	var game_scene = load("res://Scenes/GameScene.tscn").instantiate()
	#Add it to the tree of objects.
	add_child(game_scene)

func onQuit():
	#quits the game
	get_tree().quit()
