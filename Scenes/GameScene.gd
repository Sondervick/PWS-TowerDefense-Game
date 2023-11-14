extends Node2D

# Creating various variables
var map_node
var current_wave = 0
var enemies_in_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting the map_node variable to the name of the first map
	# Later this should switch automatically, when switching maps
	map_node = get_node("Map1")
	# Call the start_next_wave function on game startup
	start_next_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	var wave_data = [["OrangeTree", 0.7], ["OrangeTree", 0.1]]
	current_wave += 1
	# Getting the amount of enemies per wave, this is done by looking at the array size
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	# For every entry (i) in wave_data
	for i in wave_data:
		# Load a new enemy scene from the Scenes/Enemies folder
		# Get the name of the enemy from the Array (the name of the enemy is at place 0 in the array)
		# Add the .tscn file extension
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
		# Add the new_enemy to the Path as a child, 
		# also give it a human readable name (true).
		map_node.get_node("Path").add_child(new_enemy, true)
		# Wait the amount of seconds between spawning another enemy.
		# Wait time is defined in the second argument of the array i[1], not i[2]!!
		await(get_tree().create_timer(i[1])).timeout
	

