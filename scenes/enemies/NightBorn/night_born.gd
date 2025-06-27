extends BaseEnemy



func _ready() -> void:
	super._ready()
	frame_attack = 7


func _on_animated_sprite_2d_frame_changed() -> void:
	if anim_sprite2d and anim_sprite2d.animation == "attack":
		if anim_sprite2d.frame == frame_attack:
			attack_area.monitoring = true
			attack_area.visible = true
			attack_area.monitorable = true
			if attack_collision.position.x > 0 and anim_sprite2d.flip_h:
				attack_collision.position.x *= -1
			elif attack_collision.position.x < 0 and !anim_sprite2d.flip_h:
				attack_collision.position.x = abs(attack_collision.position.x)
			print("ataque activo")
