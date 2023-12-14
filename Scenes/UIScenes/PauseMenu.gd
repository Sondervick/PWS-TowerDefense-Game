extends Control

func _unhandled_input(event):
	#If the event is the ui_canceled (pressed escape)
	if event.is_action_released("ui_cancel"):
		#Then we want to continue the game
		_on_continue_pressed()

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
