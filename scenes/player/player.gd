extends CharacterBody2D

class_name Player

enum FACING {UP, DOWN, LEFT, RIGHT}
enum PLAYER_STATE {IDLE, WALK_UP, WALK_DOWN, WALK_LEFT, WALK_RIGHT, ATTACK, DEATH}

@onready var anim_sprite2d = $AnimatedSprite2D

@export var move_spd = 15000;
var facing_direction: FACING = FACING.DOWN
var current_state: PLAYER_STATE = PLAYER_STATE.IDLE
var is_moving: bool = false
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	player_input(delta)
	calculate_state()
	move_and_slide()

func player_input(delta: float):
	var h_move = 0
	var v_move = 0
	if !is_attacking:
		h_move = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		v_move = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	velocity.x = move_spd * h_move * delta
	velocity.y = move_spd * v_move * delta
	if (h_move != 0 and v_move != 0):
		velocity /= sqrt(2)
	
	if velocity.y != 0:
		if velocity.y > 0: facing_direction = FACING.DOWN
		else: facing_direction = FACING.UP
	if velocity.x != 0:
		if velocity.x > 0: facing_direction = FACING.RIGHT
		else: facing_direction = FACING.LEFT
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	is_attacking = true;
	set_state(PLAYER_STATE.ATTACK)

func calculate_state():
	if !is_attacking:
		if velocity.length() != 0:
			match facing_direction:
				FACING.UP:
					set_state(PLAYER_STATE.WALK_UP)
				FACING.DOWN:
					set_state(PLAYER_STATE.WALK_DOWN)
				FACING.LEFT:
					set_state(PLAYER_STATE.WALK_LEFT)
				FACING.RIGHT:
					set_state(PLAYER_STATE.WALK_RIGHT)
		else:
			set_state(PLAYER_STATE.IDLE)

func set_state(new_state: PLAYER_STATE):
	if (new_state != current_state):
		current_state = new_state
		match current_state:
			PLAYER_STATE.IDLE:
				set_idle_animation()
			PLAYER_STATE.WALK_UP:
				set_walk_animation()
			PLAYER_STATE.WALK_DOWN:
				set_walk_animation()
			PLAYER_STATE.WALK_LEFT:
				set_walk_animation()
			PLAYER_STATE.WALK_RIGHT:
				set_walk_animation()
			PLAYER_STATE.ATTACK:
				set_attack_animation()

func set_idle_animation():
	anim_sprite2d.play("neutral")
	match facing_direction:
		FACING.UP:
			anim_sprite2d.set_frame_and_progress(0,0.0)
		FACING.DOWN:
			anim_sprite2d.set_frame_and_progress(1,0.0)
		FACING.LEFT:
			anim_sprite2d.set_frame_and_progress(3,0.0)
		FACING.RIGHT:
			anim_sprite2d.set_frame_and_progress(3,0.0)

func set_walk_animation():
	match facing_direction:
		FACING.UP:
			anim_sprite2d.play("walk_up")
		FACING.DOWN:
			anim_sprite2d.play("walk_down")
		FACING.LEFT:
			anim_sprite2d.play("walk_side")
			anim_sprite2d.flip_h = true;
		FACING.RIGHT:
			anim_sprite2d.play("walk_side")
			anim_sprite2d.flip_h = false;

func set_attack_animation():
	match facing_direction:
		FACING.UP:
			anim_sprite2d.play("attack_up")
		FACING.DOWN:
			anim_sprite2d.play("attack_down")
		FACING.LEFT:
			anim_sprite2d.play("attack_side")
			anim_sprite2d.flip_h = true;
		FACING.RIGHT:
			anim_sprite2d.play("attack_side")
			anim_sprite2d.flip_h = false;

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim_sprite2d.animation in ["attack_up", "attack_side", "attack_down"]:
		reset_state()

func reset_state():
	set_state(PLAYER_STATE.IDLE)
	is_attacking = false 
