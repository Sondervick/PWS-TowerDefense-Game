extends "res://Scenes/Enemies/Enemies.gd"

func _ready():
	# You can initialize the turret with a specific damage value
	init_enemy_type("GreenTree", get_node("HealthBar").get_parent())
