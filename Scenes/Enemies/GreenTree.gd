extends PathFollow2D

var speed = 200
var health = 100
var health_bar

func _ready():
	#Get health bar
	health_bar = get_node("HealthBar")
	#Setting the max value
	health_bar.max_value = health
	#Setting the current value
	health_bar.value = health
	#Disconnecting the health_bar from the parent node, this stops rotation.
	health_bar.set_as_top_level(true)

# _physics_process is automatically called every 1/60th of a second
func _physics_process(delta):
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
	if health <= 0:
		on_destroy()

func on_destroy():
	#Destroy the object on the next available frame
	self.queue_free()
