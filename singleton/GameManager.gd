extends Node

var rng = RandomNumberGenerator.new()
var spawn_room
var w_room #West Room
var e_room #East Room
var n_room #North Room

func set_spawn_room(room: String):
	spawn_room = room

func generate_rooms():
	var random_number
	var levels = [
		"scene_lvlgt2",
		"scene_lvlgt3",
		#"scene_lvlgt4",
	]
	
	#Establece el cuarto a la izquierda
	random_number = rng.randi_range(0, levels.size()-1)
	w_room = levels[random_number]
	levels.erase(random_number)
	#Establece el cuarto a la derecha sin repetir el de la izquierda
	random_number = rng.randi_range(0, levels.size()-1)
	e_room = levels[random_number]
