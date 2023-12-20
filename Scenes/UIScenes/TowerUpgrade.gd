extends Control

var tower_type
var tower_node
var upgrade
var costs
var damage
var fire_rate
var range
var tower_pos
var money_upgrade
var tower_tilemap_pos
var tile_pos

func _ready():
	get_node("Margin/VBC-Labels/TowerName").set_text(tower_type)
	upgrade = GameData.tower_data[tower_type]["next-upgrade"]
	costs = GameData.tower_data[tower_type]["costs"]
	damage = GameData.tower_data[tower_type]["damage"]
	fire_rate = GameData.tower_data[tower_type]["fire_rate"]
	range = GameData.tower_data[tower_type]["range"]
	tower_pos = tower_node.get_global_position()
	if upgrade != "none":
		money_upgrade = GameData.tower_data[upgrade]["costs"]
	else:
		money_upgrade = -1
	
	#Get the current tile from the TowerExclusion tilemap in map_node (example: Map1)
	#world_to_map wile return the tile coordinate where the mouse currently is
	tower_tilemap_pos = GameData.map_node.get_node("TowerExclusion").local_to_map(tower_pos)
	#We're getting the tile position (coordinate) from that tile.
	tile_pos = GameData.map_node.get_node("TowerExclusion").map_to_local(tower_tilemap_pos)
	
	get_node("Margin/VBC-Buttons/SellButton/SellLabel").set_text("Sell (" + str(int(costs/2)) + ")")
	get_node("Margin/VBC-Labels/Damage").set_text("Damage: " + str(damage))
	get_node("Margin/VBC-Labels/RateOfFire").set_text("RoF: " + str(fire_rate) + " sec")
	get_node("Margin/VBC-Labels/Range").set_text("Range: " + str(range))
	
	tower_node.get_node("RangeTexture").visible = true
	
	if upgrade == "none":
		get_node("Margin/VBC-Labels/UpgradeButton").disabled = true
		get_node("Margin/VBC-Labels/UpgradeButton/UpgradeLabel").set_text("Max Upgrade")
	else:
		get_node("Margin/VBC-Labels/UpgradeButton/UpgradeLabel").set_text("Upgrade (" + str(money_upgrade) + ")")

func _on_close_pressed():
	GameData.upgrade_menu_open = false
	tower_node.get_node("RangeTexture").visible = false
	self.queue_free()

func _on_upgrade_button_pressed():
	if GameData.money >= money_upgrade:
		GameData.money -= money_upgrade
		get_parent().get_parent().get_node("HUD/InfoBar/HBoxContainer/Money").set_text(str(GameData.money))
		delete_tower_tile()
		create_tower()
		_on_close_pressed()

func _on_sell_button_pressed():
	delete_tower_tile()
	GameData.money += costs/2
	get_parent().get_parent().get_node("HUD/InfoBar/HBoxContainer/Money").set_text(str(GameData.money))
	_on_close_pressed()

func delete_tower_tile():
	#Will delete the tile (next available frame)
	tower_node.queue_free()

func create_tower():
	var range_texture = Sprite2D.new()
	var scaling = GameData.tower_data[upgrade]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/Art/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("00E522")
	range_texture.name = "RangeTexture"
	
	var upgrade_tower_node = load("res://Scenes/Towers/" + upgrade + ".tscn").instantiate()
	upgrade_tower_node.position = tile_pos
	upgrade_tower_node.type = upgrade
	upgrade_tower_node.category = GameData.tower_data[upgrade]["fire-catagory"]
	upgrade_tower_node.built = true;
	GameData.map_node.get_node("Towers").add_child(upgrade_tower_node, true)
	upgrade_tower_node.add_child(range_texture, true)
	upgrade_tower_node.get_node("RangeTexture").visible = false
	
