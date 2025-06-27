extends BaseEnemy

@onready var shoot_marker = $Marker2D

func _ready() -> void:
	super._ready()
	frame_attack = 2
	damage = 2
	movement_speed = 15000
	hp = 3

func _process(delta: float) -> void:
	var bodies_in_area = range_area.has_overlapping_bodies()
	if bodies_in_area and !can_attack:
		velocity = Vector2.ZERO

func _on_animated_sprite_2d_frame_changed() -> void:
	if anim_sprite2d and anim_sprite2d.animation == "attack":
		if anim_sprite2d.frame == frame_attack:
			print("atacando")
			ObjectMaker.create_soul_shoot(shoot_marker.global_position, player_ref.global_position)
