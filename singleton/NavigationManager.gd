extends Node

const rooms: Dictionary = {
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

signal on_trigger_player_spawn

var spawn_door_tag = null

func go_to_level(level_tag, destination_tag):
	var scene_to_load = rooms[level_tag]
	
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		call_deferred("_change_scene_safely", scene_to_load)

func _change_scene_safely(scene_to_load):
	get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
