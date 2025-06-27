extends Node

@export var soul_shoot_reference = preload("res://scenes/enemies/soulHarvester/harvester_projectile.tscn")

func create_soul_shoot(spawn_position: Vector2, player_position: Vector2):
	print("creando projectil")
	var projectile = soul_shoot_reference.instantiate()
	projectile.global_position = spawn_position
	var to_player = (player_position - spawn_position).normalized()
	projectile.set_direction(to_player)
	projectile.rotation = to_player.angle()
	get_tree().current_scene.add_child(projectile)
