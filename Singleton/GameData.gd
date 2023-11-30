extends Node

var game_mode = null

#Create a tower_data dictionary
#Creating a sub-dictionary to every tower, these will hold the range variables for example.
var tower_data = {
	"gun_tier_1": {
		"range": 750,
		"damage": 20,
		"fire_rate": 1.5,
		"costs": 75
	}, 
	"gun_tier_2": {
		"range": 1000,
		"damage": 45,
		"fire_rate": 1,
		"costs": 150
	},
	"missile_tier_1": {
		"range": 500,
		"damage": 90,
		"fire_rate": 3,
		"costs": 100
	} 
}
