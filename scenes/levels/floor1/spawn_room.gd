extends Node2D

@onready var door_w: Door = $Door_W
@onready var door_e: Door = $Door_E
@onready var door_s: Door = $Door_S
@onready var door_n: Door = $Door_N
@onready var lock_w := $LockW
@onready var lock_w_collision := $LockW/CollisionShape2D
@onready var lock_e := $LockE
@onready var lock_e_collision := $LockE/CollisionShape2D
@onready var lock_s := $LockS
@onready var lock_s_collision := $LockS/CollisionShape2D
@onready var lock_n := $LockN
@onready var lock_n_collision := $LockN/CollisionShape2D

func _ready() -> void:
	print("gm level tag: ",GameManager.e_room)
	door_e.destination_level_tag = GameManager.e_room
	door_w.destination_level_tag = GameManager.w_room
	door_s.destination_level_tag = GameManager.s_room
	door_n.destination_level_tag = GameManager.n_room
	print("East: ",door_e.destination_level_tag)
	print("West: ",door_w.destination_level_tag)
	print("South: ",door_s.destination_level_tag)
	print("North: ",door_n.destination_level_tag)
	
	lock_w.visible = RoomManager.door_locked_w
	lock_w_collision.disabled = !RoomManager.door_locked_w
	lock_e.visible = RoomManager.door_locked_e
	lock_e_collision.disabled = !RoomManager.door_locked_e
	lock_s.visible = RoomManager.door_locked_s
	lock_s_collision.disabled = !RoomManager.door_locked_s
	lock_n.visible = RoomManager.door_locked_n
	lock_n_collision.disabled = !RoomManager.door_locked_n
	
	if NavigationManager.spawn_door_tag != null:
		on_level_spawn(NavigationManager.spawn_door_tag)

func on_level_spawn(destination_tag: String):
	var door_path = "Door_" + destination_tag
	var door = get_node(door_path) as Door
	if door is Door:
		NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
