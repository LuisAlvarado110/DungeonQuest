extends Node

const rooms: Dictionary = {
	"scene_lvlgt1": preload("res://scenes/LevelGenTesting/LevelGenTesting1.tscn"),
	
	"floor1_spawn": preload("res://scenes/levels/floor1/spawn_room.tscn"),
	
	"west_testing1": preload("res://scenes/LevelGenTesting/WestRoom/WestTesting1.tscn"),
	"west_testing2": preload("res://scenes/LevelGenTesting/WestRoom/WestTesting2.tscn"),
	"west_testing3": preload("res://scenes/LevelGenTesting/WestRoom/WestTesting3.tscn"),
	
	"south_testing1": preload("res://scenes/LevelGenTesting/SouthRoom/SouthTesting1.tscn"),
	"south_testing2": preload("res://scenes/LevelGenTesting/SouthRoom/SouthTesting2.tscn"),
	"south_testing3": preload("res://scenes/LevelGenTesting/SouthRoom/SouthTesting3.tscn"),
	
	"east_testing1": preload("res://scenes/LevelGenTesting/EastRoom/EastTesting1.tscn"),
	"east_testing2": preload("res://scenes/LevelGenTesting/EastRoom/EastTesting2.tscn"),
	"east_testing3": preload("res://scenes/LevelGenTesting/EastRoom/EastTesting3.tscn"),
	
	"north_testing1": preload("res://scenes/LevelGenTesting/NorthRoom/NorthTesting1.tscn"),
	"north_testing2": preload("res://scenes/LevelGenTesting/NorthRoom/NorthTesting2.tscn"),
	"north_testing3": preload("res://scenes/LevelGenTesting/NorthRoom/NorthTesting3.tscn"),
}

var loaded_rooms: Dictionary

signal on_trigger_player_spawn

var spawn_door_tag = null

func load_floor_rooms(floor: int):
	match floor:
		-1:
			loaded_rooms = {
				"scene_lvlgt1": preload("res://scenes/LevelGenTesting/LevelGenTesting1.tscn"),
				"west_testing1": preload("res://scenes/LevelGenTesting/WestRoom/WestTesting1.tscn"),
				"west_testing2": preload("res://scenes/LevelGenTesting/WestRoom/WestTesting2.tscn"),
				"west_testing3": preload("res://scenes/LevelGenTesting/WestRoom/WestTesting3.tscn"),
				"south_testing1": preload("res://scenes/LevelGenTesting/SouthRoom/SouthTesting1.tscn"),
				"south_testing2": preload("res://scenes/LevelGenTesting/SouthRoom/SouthTesting2.tscn"),
				"south_testing3": preload("res://scenes/LevelGenTesting/SouthRoom/SouthTesting3.tscn"),
				"east_testing1": preload("res://scenes/LevelGenTesting/EastRoom/EastTesting1.tscn"),
				"east_testing2": preload("res://scenes/LevelGenTesting/EastRoom/EastTesting2.tscn"),
				"east_testing3": preload("res://scenes/LevelGenTesting/EastRoom/EastTesting3.tscn"),
				"north_testing1": preload("res://scenes/LevelGenTesting/NorthRoom/NorthTesting1.tscn"),
				"north_testing2": preload("res://scenes/LevelGenTesting/NorthRoom/NorthTesting2.tscn"),
				"north_testing3": preload("res://scenes/LevelGenTesting/NorthRoom/NorthTesting3.tscn"),
			}
		1:
			loaded_rooms = {
				"floor1_spawn": preload("res://scenes/levels/floor1/spawn_room.tscn"),
				"west_1": preload("res://scenes/levels/floor1/west/floor_1_west.tscn"),
				"east_1": preload("res://scenes/levels/floor1/east/floor1_east.tscn"),
				"south_1": preload("res://scenes/levels/floor1/south/floor1_south.tscn"),
				"north_1": preload("res://scenes/levels/floor1/north/floor1_north.tscn"),
			}

func go_to_level(level_tag, destination_tag):
	var scene_to_load = loaded_rooms[level_tag]
	
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		call_deferred("_change_scene_safely", scene_to_load)

func _change_scene_safely(scene_to_load):
	get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
