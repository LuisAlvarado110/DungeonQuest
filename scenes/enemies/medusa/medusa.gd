extends BaseEnemy

@onready var marker: Marker2D = $Marker2D
@onready var second_phase_timer = $SecondPhaseTimer

const MEDUSA_STATES = {
	"IDLE": ENEMY_STATES.IDLE,
	"RUN": ENEMY_STATES.RUN,
	"ATTACK": ENEMY_STATES.ATTACK,
	"HIT": ENEMY_STATES.HIT,
	"DEATH": ENEMY_STATES.DEATH,
	"TRANSFORMATION": 5,
	"SECOND_PHASE": 6
}


func _ready() -> void:
	super._ready()
	frame_attack = 3
	damage = 2
	movement_speed = 18000
	hp = 6

func _process(delta: float) -> void:
	if current_state != MEDUSA_STATES.DEATH:
		match current_state:
			MEDUSA_STATES.TRANSFORMATION:
				anim_sprite2d.play("false_death")
			MEDUSA_STATES.SECOND_PHASE:
				if second_phase_timer.is_stopped():
					second_phase_timer.start()
				anim_sprite2d.play("second_phase")
		if hp <= 0:
			anim_sprite2d.play("death")
		elif hp <= 5 and current_state != MEDUSA_STATES.TRANSFORMATION and current_state != MEDUSA_STATES.SECOND_PHASE:
			current_state = MEDUSA_STATES.TRANSFORMATION
	var bodies_in_area = range_area.has_overlapping_bodies()
	if bodies_in_area and !can_attack:
		velocity = Vector2.ZERO

func _on_animated_sprite_2d_frame_changed() -> void:
	if anim_sprite2d and anim_sprite2d.animation == "attack":
		if anim_sprite2d.frame == frame_attack:
			ObjectMaker.create_medusa_attack(marker.global_position, player_ref.global_position)
	if anim_sprite2d and anim_sprite2d.animation == "death":
		if anim_sprite2d.frame == 17:
			queue_free()
	if anim_sprite2d and anim_sprite2d.animation == "false_death":
		if anim_sprite2d.frame == 10:
			current_state = MEDUSA_STATES.SECOND_PHASE
	if anim_sprite2d and anim_sprite2d.animation == "second_phase":
		if anim_sprite2d.frame == 2 or anim_sprite2d.frame == 4:
			ObjectMaker.create_soul_shoot(marker.global_position, player_ref.global_position)
			ObjectMaker.create_soul_shoot(marker.global_position, player_ref.global_position)


func _on_second_phase_timer_timeout() -> void:
	current_state = MEDUSA_STATES.DEATH
