extends CharacterBody2D

class_name Player

enum FACING {UP, DOWN, LEFT, RIGHT}
enum PLAYER_STATE {IDLE, WALK_UP, WALK_DOWN, WALK_LEFT, WALK_RIGHT,
RUN_UP, RUN_DOWN, RUN_LEFT, RUN_RIGHT, ATTACK, DEATH}

@onready var anim_sprite2d = $AnimatedSprite2D
@onready var attack_areaUP : Area2D = $AtackUp
@onready var attack_areaDOWN : Area2D = $AtackDown
@onready var attack_areaLEFT : Area2D = $AtackLeft
@onready var attack_areaRIGHT : Area2D = $AtackRight

@export var run_spd = 1
@export var move_spd = 15000
@export var hp: int = 10
@export var strenght: int = 2

var facing_direction: FACING = FACING.DOWN
var current_state: PLAYER_STATE = PLAYER_STATE.IDLE
var is_moving: bool = false
var is_running: bool = false
var is_attacking: bool = false

func _ready() -> void:
	reset_state()

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
	
	is_running = Input.is_action_pressed("run")
	run_spd = 2.0 if(is_running) else 1.0
	
	velocity.x = move_spd * h_move * delta * run_spd
	velocity.y = move_spd * v_move * delta * run_spd
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
			print("Velocidad: ", velocity.length())
			match facing_direction:
				FACING.UP:
					set_state(PLAYER_STATE.RUN_UP if is_running else PLAYER_STATE.WALK_UP)
				FACING.DOWN:
					set_state(PLAYER_STATE.RUN_DOWN if is_running else PLAYER_STATE.WALK_DOWN)
				FACING.LEFT:
					set_state(PLAYER_STATE.RUN_LEFT if is_running else PLAYER_STATE.WALK_LEFT)
				FACING.RIGHT:
					set_state(PLAYER_STATE.RUN_RIGHT if is_running else PLAYER_STATE.WALK_RIGHT)
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
			PLAYER_STATE.RUN_UP:
				set_run_animation()
			PLAYER_STATE.RUN_DOWN:
				set_run_animation()
			PLAYER_STATE.RUN_LEFT:
				set_run_animation()
			PLAYER_STATE.RUN_RIGHT:
				set_run_animation()
			PLAYER_STATE.ATTACK:
				set_attack_animation()

func set_idle_animation():
	match facing_direction:
		FACING.UP:
			anim_sprite2d.play("idle_up")
		FACING.DOWN:
			anim_sprite2d.play("idle_down")
		FACING.LEFT:
			anim_sprite2d.play("idle_side")
			anim_sprite2d.flip_h = true;
		FACING.RIGHT:
			anim_sprite2d.play("idle_side")
			anim_sprite2d.flip_h = false;

func set_run_animation():
	match facing_direction:
		FACING.UP:
			anim_sprite2d.play("run_up")
		FACING.DOWN:
			anim_sprite2d.play("run_down")
		FACING.LEFT:
			anim_sprite2d.play("run_side")
			anim_sprite2d.flip_h = true;
		FACING.RIGHT:
			anim_sprite2d.play("run_side")
			anim_sprite2d.flip_h = false;

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
			attack_areaUP.monitoring = true
			attack_areaUP.monitorable = true
			attack_areaUP.visible = true
			anim_sprite2d.play("attack_up")
		FACING.DOWN:
			attack_areaDOWN.monitoring = true
			attack_areaDOWN.monitorable = true
			attack_areaDOWN.visible = true
			anim_sprite2d.play("attack_down")
		FACING.LEFT:
			attack_areaLEFT.monitoring = true
			attack_areaLEFT.monitorable = true
			attack_areaLEFT.visible = true
			anim_sprite2d.play("attack_side")
			anim_sprite2d.flip_h = true;
		FACING.RIGHT:
			attack_areaRIGHT.monitoring = true
			attack_areaRIGHT.monitorable = true
			attack_areaRIGHT.visible = true
			anim_sprite2d.play("attack_side")
			anim_sprite2d.flip_h = false;

func reset_state():
	set_state(PLAYER_STATE.IDLE)
	attack_areaDOWN.monitoring = false
	attack_areaUP.monitoring = false
	attack_areaLEFT.monitoring = false
	attack_areaRIGHT.monitoring = false
	
	attack_areaDOWN.monitorable = false
	attack_areaUP.monitorable = false
	attack_areaLEFT.monitorable = false
	attack_areaRIGHT.monitorable = false
	
	attack_areaDOWN.visible = false
	attack_areaUP.visible = false
	attack_areaLEFT.visible = false
	attack_areaRIGHT.visible = false
	
	is_attacking = false 


func _on_animation_attack_finished() -> void:
	if anim_sprite2d.animation in ["attack_up", "attack_side", "attack_down"]:
		reset_state()
