extends PathFollow2D

var speed = 150

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
