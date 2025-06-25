extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction = "up"
@export var player : Player

@onready var spawn = $Spawn

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Loading scene: ",destination_level_tag)
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)


func _on_area_entered(area: Area2D) -> void:
	print("area has entered")
	if area.get_parent() is Player:
		print("area is player")#NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
