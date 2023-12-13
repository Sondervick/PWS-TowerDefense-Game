extends Node

var game_mode = null
var money = 100
var enemies_in_wave = 0

#Create a tower_data dictionary
#Creating a sub-dictionary to every tower, these will hold the range variables for example.
var tower_data = {
	"gun_tier_1": {
		"range": 750,
		"damage": 20,
		"fire_rate": 1.5,
		"costs": 75,
		"fire-catagory": "Bullet"
	}, 
	"gun_tier_2": {
		"range": 1000,
		"damage": 45,
		"fire_rate": 1,
		"costs": 150,
		"fire-catagory": "Bullet"
	},
	"missile_tier_1": {
		"range": 500,
		"damage": 90,
		"fire_rate": 3,
		"costs": 100,
		"fire-catagory": "Missle"
	} 
}

var enemy_data = {
	"EnemySexyMf": {
		"speed": 250,
		"damage": 50,
		"health": 40,
		"money_earned": 30
	}, 
	"GreenTree": {
		"speed": 150,
		"damage": 25,
		"health": 150,
		"money_earned": 20
	},
	"OrangeTree": {
		"speed": 100,
		"damage": 10,
		"health": 100,
		"money_earned": 10
	} 
}
