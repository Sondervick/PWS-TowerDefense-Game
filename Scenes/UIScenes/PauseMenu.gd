extends Control

func _on_continue_pressed():
	#Everything is currently paused so, unpause
	get_tree().paused = false
	#Make the pause button show that the game is playing again
	get_parent().get_node("HUD/GameControls/PausePlay").button_pressed = true
	#Then delete the scene again, since we want to continue
	self.queue_free()

func _on_main_menu_pressed():
	#Everything is currently paused, meaning we will have to unpause the game
	get_tree().paused = false
	#Then reload the scene to go to main menu
	get_tree().reload_current_scene()
