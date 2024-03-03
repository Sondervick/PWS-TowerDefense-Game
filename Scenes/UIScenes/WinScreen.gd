extends Node2D
@export var MainMenuBTN: TextureButton = null
@export var GameScene: PackedScene = null
# Called when the node enters the scene tree for the first time.
func _ready():
	MainMenuBTN.pressed.connect(_on_main_menu_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_pressed():
	get_tree().reload_current_scene()


func _on_level_select_pressed():
	pass
	# Replace with function body.
	#self --> dit object
	#queue_free() verwijder dit object in de eerst volgende frame
	self.queue_free()
	#laad de nieuwe scene naar een variabele genaamd new_scene
	var new_scene = load("res://Scenes/GameScene.tscn").instantiate()
	var ny_new_scene = GameScene.instantiate()
	#haal de parent op (in dit geval scene handler)
	#voeg de niewe scene toe aan de parent
	get_parent().add_child(new_scene)
	
