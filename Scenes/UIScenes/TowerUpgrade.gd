extends Control

var tower_type
var upgrade
var costs
var damage
var fire_rate
var range

func _ready():
	get_node("Margin/VBC-Labels/TowerName").set_text(tower_type)
	upgrade = GameData.tower_data[tower_type]["next-upgrade"]
	costs = GameData.tower_data[tower_type]["costs"]
	damage = GameData.tower_data[tower_type]["damage"]
	fire_rate = GameData.tower_data[tower_type]["fire_rate"]
	range = GameData.tower_data[tower_type]["range"]
	get_node("Margin/VBC-Buttons/SellButton/SellLabel").set_text("Sell (" + str(int(costs/2)) + ")")
	get_node("Margin/VBC-Labels/Damage").set_text("Damage: " + str(damage))
	get_node("Margin/VBC-Labels/RateOfFire").set_text("RoF: " + str(fire_rate) + " sec")
	get_node("Margin/VBC-Labels/Range").set_text("Range: " + str(range))
	
	if upgrade == "none":
		get_node("Margin/VBC-Labels/UpgradeButton").disabled = true
		get_node("Margin/VBC-Labels/UpgradeButton/UpgradeLabel").set_text("Max Upgrade")
	

func _on_close_pressed():
	self.queue_free()


func _on_upgrade_button_pressed():
	print(upgrade)


func _on_sell_button_pressed():
	print(int(costs/2))
