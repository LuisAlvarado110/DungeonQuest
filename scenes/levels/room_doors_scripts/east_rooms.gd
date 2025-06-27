extends Node2D

@onready var door_e: Door = $Door_W
#@onready var doors_tml: TileMapLayer = $Doors

func _ready() -> void:
	#doors_tml.enabled = false
	door_e.destination_level_tag = GameManager.spawn_room
	door_e.destination_door_tag = "E"
	if NavigationManager.spawn_door_tag != null:
		on_level_spawn(NavigationManager.spawn_door_tag)

func on_level_spawn(destination_tag: String):
	var door_path = "Door_" + destination_tag
	var door = get_node(door_path) as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
