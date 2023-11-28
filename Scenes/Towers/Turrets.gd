extends Node2D

#Runs as the scene initializes, when it's added to the tree of objects
func _init():
	pass

#Runs when the scene has finished loading into the game (after init)
func _ready():
	pass

#Called every graphical frame that has been rendered.
#Delta = the amount of time between calling the function again.
func _process(delta):
	pass

#Called every physics frame (you can change this in godot settings, default: 60fps)
func _physics_process(delta):
	#Imitating enemy position for now, this will alwyas look at your mouse cursor
	turn()

func turn():
	#Setting the variable enemy_position to the mouse position (vector 2D).
	var enemy_position = get_global_mouse_position()
	#Getting the turret (gun) node, and setting the rotation to the enemy_position
	get_node("Turret").look_at(enemy_position)
