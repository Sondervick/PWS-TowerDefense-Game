extends Node2D

var type
var enemy_array = []
var built = false
var enemy

func _ready():
	if built:
		#Get the CollisionShape2D and set it to the radius defined in the tower nodes
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

#Called every physics frame (you can change this in godot settings, default: 60fps)
func _physics_process(delta):
	if GameData.game_mode != "normal":
		turn_mouse()
	else:
		if enemy_array.size() != 0 and built:
			select_enemy()
			turn()
		else:
			enemy = null

func turn_mouse():
	#Setting the variable enemy_position to the mouse position (vector 2D).
	var enemy_position = get_global_mouse_position()
	#Getting the turret (gun) node, and setting the rotation to the enemy_position
	get_node("Turret").look_at(enemy_position)

func select_enemy():
	var enemy_progress_arr = []
	# For every item in the enemy_array
	for i in enemy_array:
		#Adding the offset of the enemy
		enemy_progress_arr.append(i.get_progress())
	# Getting the maximum offset
	var max_offset = enemy_progress_arr.max()
	# Focus on the enemy closest to the end of the path
	var enemy_index = enemy_progress_arr.find(max_offset)
	if enemy_index != -1:  # Check if the index is valid
		enemy = enemy_array[enemy_index]

func turn():
	#Look at the enemy
	get_node("Turret").look_at(enemy.get_global_position())

func _on_range_body_entered(body):
	#Add the enemy parent from the array
	enemy_array.append(body.get_parent())


func _on_range_body_exited(body):
	#Remove the enemy parent from the array
	enemy_array.erase(body.get_parent())
