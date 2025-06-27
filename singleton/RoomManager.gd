extends Node

var door_locked_n := true
var door_locked_s := false
var door_locked_w := false
var door_locked_e := false
var door_locked_arena := true

signal on_change_lock

func restart_locks():
	door_locked_n = true
	door_locked_s = false
	door_locked_w = false
	door_locked_e = false
	door_locked_arena = true

func change_lock(door: String, is_locked: bool):
	on_change_lock.emit(door, is_locked)
#	match door:
#		"east":
#			door_locked_e = is_locked
#		"west":
#			door_locked_w = is_locked
#		"north":
#			door_locked_n = is_locked
#		"south":
#			door_locked_s = is_locked
#		"arena":
#			door_locked_arena = is_locked
