extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var fire_ready = true
var category
var upgrade_menu_open = false

func _ready():
	if built:
		#Get the CollisionShape2D and set it to the radius defined in the tower nodes
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]
		get_node("UpgradeMenu").visible = true
		self.get_node("UpgradeMenu").pressed.connect(onUpgradeMenu)

#Called every physics frame (you can change this in godot settings, default: 60fps)
func _physics_process(delta):
	if built:
		if GameData.game_mode == "manual_aim":
			turn_mouse()
			if fire_ready:
				fire()
		elif GameData.game_mode == "normal":
			if enemy_array.size() != 0:
				select_enemy()
				turn()
				if fire_ready:
					fire()
			else:
				enemy = null

func turn_mouse():
	print("turn called")
	#Get mouse pos
	var mouse_pos = get_global_mouse_position()
	#Make turret look at mouse pos
	get_node("Turret").look_at(mouse_pos)

	#Get turret pos
	var turret_pos = get_node("Turret").get_global_position()

	#Draw a line from mouse pos to tower pos
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(mouse_pos, turret_pos)
	var result = space_state.intersect_ray(query)
	
	#If it hits
	if result:
		#Get the parent of the collision body
		enemy = result.collider.get_parent()
	#if it doesn't hit, make enemy null
	else:
		enemy = null

func select_enemy():
	var enemy_progress_arr = []
	#For every item in the enemy_array
	for i in enemy_array:
		#Adding the offset of the enemy
		enemy_progress_arr.append(i.get_progress())
	#Getting the maximum progress
	var max_offset = enemy_progress_arr.max()
	#Focus on the enemy closest to the end of the path
	var enemy_index = enemy_progress_arr.find(max_offset)
	if enemy_index != -1:  #Check if the index is valid
		enemy = enemy_array[enemy_index]

func turn():
	#Look at the enemy
	get_node("Turret").look_at(enemy.get_global_position())

func fire():
	#Setting the fire_ready variable to false so that it does not fire when the _physics_process runs again
	fire_ready = false
	
	if category == "Bullet":
		fire_gun()
	elif category == "Missile":
		fire_missile()
	
	if enemy != null:
		#Get the amount of damage we need to do to the enemy
		enemy.on_hit(GameData.tower_data[type]["damage"])
	
	#Wait for a the fire_rate to pass, then set fire_ready to true to fire again.
	await(get_tree().create_timer(GameData.tower_data[type]["fire_rate"], false).timeout)
	fire_ready = true

func fire_gun():
	#Get the animation player and play the "Fire" animation
	get_node("AnimationPlayer").play("Fire")

func fire_missile():
	pass

func onUpgradeMenu():
	if GameData.upgrade_menu_open:
		get_parent().get_parent().get_parent().get_node("UI/HUD/TowerUpgrade").free()
	GameData.upgrade_menu_open = true
	
	var upgrade_menu = load("res://Scenes/UIScenes/TowerUpgrade.tscn").instantiate()
	upgrade_menu.tower_type = type
	upgrade_menu.tower_node = self
	get_parent().get_parent().get_parent().get_node("UI/HUD").add_child(upgrade_menu, true)

func _on_range_body_entered(body):
	#Add the enemy parent from the array
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	#Remove the enemy parent from the array
	enemy_array.erase(body.get_parent())
