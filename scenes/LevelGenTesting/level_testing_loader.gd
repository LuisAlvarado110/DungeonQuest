extends Node2D

func _ready() -> void:
	GameManager.set_spawn_room("scene_lvlgt1")
	GameManager.generate_rooms()
	NavigationManager.go_to_level(GameManager.spawn_room,"C")
