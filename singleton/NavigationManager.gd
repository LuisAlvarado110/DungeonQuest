extends Node

const rooms: Dictionary = {
	"scene_lvlgt1": preload("res://scenes/LevelGenTesting/LevelGenTesting1.tscn"),
	"scene_lvlgt2": preload("res://scenes/LevelGenTesting/LevelGenTesting2.tscn"),
	"scene_lvlgt3": preload("res://scenes/LevelGenTesting/LevelGenTesting3.tscn"),
	"scene_lvlgt4": preload("res://scenes/LevelGenTesting/LevelGenTesting4.tscn")
}

signal on_trigger_player_spawn

var spawn_door_tag = null

func get_room_tag(current_scene: String):
	pass
		

func go_to_level(level_tag, destination_tag):
	var scene_to_load = null
	
	match level_tag:
		"scene_lvlgt1":
			scene_to_load = rooms["scene_lvlgt1"]
		"scene_lvlgt2":
			scene_to_load = rooms["scene_lvlgt2"]
		"scene_lvlgt3":
			scene_to_load = rooms["scene_lvlgt3"]
		
	if scene_to_load != null:
		print(scene_to_load)
		spawn_door_tag = destination_tag
		call_deferred("_change_scene_safely", scene_to_load)

func _change_scene_safely(scene_to_load):
	get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
