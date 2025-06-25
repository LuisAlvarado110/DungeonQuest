extends Node

const scene_lvlgt1 = preload("res://scenes/LevelGenTesting/LevelGenTesting1.tscn")
const scene_lvlgt2 = preload("res://scenes/LevelGenTesting/LevelGenTesting2.tscn")

signal on_trigger_player_spawn

var spawn_door_tag = null

func go_to_level(level_tag, destination_tag):
	var scene_to_load = null
	
	match level_tag:
		"LevelGenTesting1":
			scene_to_load = scene_lvlgt1
		"LevelGenTesting2":
			scene_to_load = scene_lvlgt2
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		call_deferred("_change_scene_safely", scene_to_load)

func _change_scene_safely(scene_to_load):
	get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
