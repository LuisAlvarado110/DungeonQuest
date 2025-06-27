extends Node


var lvl_tmp_scene = preload("res://scenes/levels/level_template.tscn")
var lvl_tst = preload("res://scenes/LevelGenTesting/LevelTestingLoader.tscn")


var rng = RandomNumberGenerator.new()
var spawn_room
var w_room #West Room
var e_room #East Room
var n_room #North Room
var s_room #South Room

func set_spawn_room(room: String):
	spawn_room = room

func generate_rooms():
	var west_rooms: Array
	var south_rooms: Array
	var east_rooms: Array
	var north_rooms: Array
	
	for room_key in NavigationManager.loaded_rooms.keys():
		if str(room_key).contains("west"):
			west_rooms.append(str(room_key))
		elif str(room_key).contains("east"):
			east_rooms.append(str(room_key))
		elif str(room_key).contains("south"):
			south_rooms.append(str(room_key))
		elif str(room_key).contains("north"):
			north_rooms.append(str(room_key))
	
	if not west_rooms.is_empty():
		w_room = west_rooms[rng.randi_range(0, west_rooms.size()-1)]
	if not south_rooms.is_empty():
		s_room = south_rooms[rng.randi_range(0, south_rooms.size()-1)]
	if not east_rooms.is_empty():
		e_room = east_rooms[rng.randi_range(0, east_rooms.size()-1)]
	if not north_rooms.is_empty():
		n_room = north_rooms[rng.randi_range(0, north_rooms.size()-1)]

func on_lvl_tst():
	var game_scene
	get_tree().change_scene_to_packed(lvl_tst)

func on_lvl_tmp():
	get_tree().change_scene_to_packed(lvl_tmp_scene)

func on_exit():
	get_tree().quit()

func update_hp_player(hp_player: int):
	SignalManager.on_hp_update.emit(hp_player)
