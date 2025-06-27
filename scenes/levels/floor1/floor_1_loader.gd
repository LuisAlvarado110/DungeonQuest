extends Node2D

func _ready() -> void:
	NavigationManager.load_floor_rooms(1)
	GameManager.set_spawn_room("floor1_spawn")
	GameManager.generate_rooms()
	NavigationManager.go_to_level(GameManager.spawn_room,"C")
