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
	var random_number
	var west_rooms = [
		"west_testing1",
		"west_testing2",
		"west_testing3",
	]
	var south_rooms = [
		"south_testing1",
		"south_testing2",
		"south_testing3",
	]
	var east_rooms = [
		"east_testing1",
		"east_testing2",
		"east_testing3",
	]
	
	var north_rooms = [
		"north_testing1",
		"north_testing2",
		"north_testing3",
	]
	
	w_room = west_rooms[rng.randi_range(0, west_rooms.size()-1)]
	s_room = south_rooms[rng.randi_range(0, south_rooms.size()-1)]
	e_room = east_rooms[rng.randi_range(0, east_rooms.size()-1)]
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
