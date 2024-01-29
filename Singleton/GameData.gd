extends Node

var game_mode = null
var money = 100
var enemies_in_wave = 0
var map_node
var current_wave = 0

var upgrade_menu_open = false

#Create a tower_data dictionary
#Creating a sub-dictionary to every tower, these will hold the range variables for example.
var tower_data = {
	"gun_tier_1": {
		"range": 500,
		"damage": 20,
		"fire_rate": 1.5,
		"costs": 75,
		"fire-catagory": "Bullet",
		"next-upgrade": "gun_tier_2"
	}, 
	"gun_tier_2": {
		"range": 750,
		"damage": 30,
		"fire_rate": 0.75,
		"costs": 150,
		"fire-catagory": "Bullet",
		"next-upgrade": "none"
	},
	"missile_tier_1": {
		"range": 750,
		"damage": 90,
		"fire_rate": 2,
		"costs": 100,
		"fire-catagory": "Missle",
		"next-upgrade": "none"
	} 
}

var enemy_data = {
	"EnemySexyMf": {
		"speed": 250,
		"damage": 50,
		"health": 40,
		"money_earned": 15
	}, 
	"Tank": {
		"speed": 150,
		"damage": 25,
		"health": 150,
		"money_earned": 20
	},
	"Drone": {
		"speed": 100,
		"damage": 10,
		"health": 100,
		"money_earned": 10
	} 
}

#All the seperate waves
var wave_data = {
	1: {
		"wave_data" = [["EnemySexyMf", 0.7], ["Tank", 0.3], ["Drone", 0.4], ["EnemySexyMf", 0.2], ["Drone", 0.1]],
		"last_wave" = false
	},
	2: {
		"wave_data" = [["EnemySexyMf", 0.2], ["EnemySexyMf", 0.5], ["Drone", 0.3], ["Tank", 0.1], ["Drone", 0.3], ["EnemySexyMf", 0.3], ["Tank", 0.3], ["Tank", 0.5]],
		"last_wave" = false
	},
	3: {
		"wave_data" = [["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2], ["EnemySexyMf", 0.2]],
		"last_wave" = false
	},
	4: {
		"wave_data" = [["Tank", 0.6], ["EnemySexyMf", 0.5], ["Drone", 0.3], ["Drone", 0.2], ["Tank", 0.3], ["EnemySexyMf", 0.3]],
		"last_wave" = false
	},
	5: {
		"wave_data" = [["EnemySexyMf", 0.2], ["EnemySexyMf", 0.1], ["Drone", 0.5], ["Tank", 0.2], ["EnemySexyMf", 0.3], ["Tank", 0.4], ["Drone", 0.2], ["Tank", 0.4], ["Tank", 0.6], ["Drone", 0.2], ["EnemySexyMf", 0.3]],
		"last_wave" = true
	}
}
