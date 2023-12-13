extends PathFollow2D

signal base_damage(damage)
signal turret_initialized(damage)

var enemy_type = null
var enemy = null
var health_bar = null
var health_bar_label = null

var health = null
var speed = null
var money_earned = null
var damage = null

# This function can be called to initialize the turret with specific values
func init_enemy_type(type_enemy, enemy_node):
	enemy_type = type_enemy
	enemy = enemy_node
	health_bar = enemy_node.get_node("HealthBar")
	health_bar_label= enemy_node.get_node("HealthBar/Health")
	
	health = int(GameData.enemy_data[enemy_type]["health"])
	speed = int(GameData.enemy_data[enemy_type]["speed"])
	damage = int(GameData.enemy_data[enemy_type]["damage"])
	money_earned = int(GameData.enemy_data[enemy_type]["money_earned"])
	
	#Setting the max value of the healthbar
	health_bar.max_value = health
	#Setting the current value
	health_bar.value = health
	#Disconnecting the health_bar from the parent node, this stops rotation.
	health_bar.set_as_top_level(true)
	
	health_bar_label.set_text(str(health))

# _physics_process is automatically called every 1/60th of a second
func _physics_process(delta):
	#If the tank is at the end of the path
	if progress_ratio == 1.0:
		#Send out the signal named base damage
		emit_signal("base_damage", damage)
		GameData.enemies_in_wave -= 1
		self.queue_free()
	#we want it to execute the move function
	move(delta)

func move(delta):
	#We want to set the progress from the path to:
		#the current progress
		# + the speed
		# * the delta (the time it took since the last time this function ran)
	set_progress(get_progress() + speed * delta)
	#Setting the health bar position above the enemy.
	#Subtracting a Vector2 from the position to correctly display it above the player, else it would be on the player
	health_bar.position = position - Vector2(30,30)
	

func on_hit(damage):
	#Remove the damage from the health
	health -= damage
	#Setting the new health value to the health bar
	health_bar.value = health
	#If health is equal or lower than 0, delete object
	health_bar_label.set_text(str(health))
	if health <= 0:
		on_destroy()

func on_destroy():
	grant_money(money_earned)
	#decrement the enemies in wave variable
	GameData.enemies_in_wave -= 1
	
	#if enemies in wave is lower or equal to 0
	if GameData.enemies_in_wave <= 0:
		#Reload the scene (should be a different solution later)
		get_tree().reload_current_scene()
	
	#Destroy the object on the next available frame
	self.queue_free()

func grant_money(money):
	money += GameData.money
	GameData.money = money
	get_tree().get_root().get_node("/root/SceneHandler/GameScene/UI").update_money(money)
