extends CharacterBody2D

class_name Player

enum FACING {UP, DOWN, LEFT, RIGHT}
enum PLAYER_STATE {IDLE, WALK_UP, WALK_DOWN, WALK_LEFT, WALK_RIGHT,
				   RUN_UP, RUN_DOWN, RUN_LEFT, RUN_RIGHT, 
				   ATTACK_UP, ATTACK_DOWN, ATTACK_LEFT, ATTACK_RIGHT, DEATH, HIT}

@onready var anim_sword = $%Animated_sword
@onready var sword_marker = $Sword
@onready var anim_sprite2d = $AnimatedSprite2D
@onready var attack_areaUP : Area2D = $AtackUp
@onready var attack_areaDOWN : Area2D = $AtackDown
@onready var attack_areaLEFT : Area2D = $AtackLeft
@onready var attack_areaRIGHT : Area2D = $AtackRight
@onready var hitbox: Area2D = $Hitbox
@onready var invincible_timer = $InvincibleTimer

@export var run_spd = 1
@export var move_spd = 10000
@export var hp: int = 2
@export var strenght: int = 2

var facing_direction: FACING = FACING.DOWN
var current_state: PLAYER_STATE = PLAYER_STATE.IDLE
var is_moving: bool = false
var is_running: bool = false
var is_attacking: bool = false
var is_dead: bool = false

func _ready() -> void:
	reset_state()
	print("Hitbox en _ready:", hitbox)
	anim_sprite2d.play("idle_down")
	NavigationManager.on_trigger_player_spawn.connect(on_spawn)
	anim_sword.connect("animation_finished", Callable(self, "_on_sword_animation_finished"))


func on_spawn(position: Vector2, direction: String):
	global_position = position
	#print(direction)

func _physics_process(delta: float) -> void:
	player_input(delta)
	if !is_dead:
		calculate_state()
		move_and_slide()

func player_input(delta: float):
	var h_move = 0
	var v_move = 0
	
	if is_dead:
		return
	
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
		take_dmg()

func attack():
	is_attacking = true;
	calculate_state()

func calculate_state():
	if is_attacking:
		match facing_direction:
			FACING.UP:
				set_state(PLAYER_STATE.ATTACK_UP)
			FACING.DOWN:
				set_state(PLAYER_STATE.ATTACK_DOWN)
			FACING.LEFT:
				set_state(PLAYER_STATE.ATTACK_LEFT)
			FACING.RIGHT:
				set_state(PLAYER_STATE.ATTACK_RIGHT)
	else:
		if velocity.length() != 0:
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
	if is_dead and new_state != PLAYER_STATE.DEATH:
		return
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
			PLAYER_STATE.ATTACK_UP:
				set_attack_animation()
			PLAYER_STATE.ATTACK_DOWN:
				set_attack_animation()
			PLAYER_STATE.ATTACK_LEFT:
				set_attack_animation()
			PLAYER_STATE.ATTACK_RIGHT:
				set_attack_animation()
			PLAYER_STATE.HIT:
				take_dmg()
			PLAYER_STATE.DEATH:
				death()

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
			sword_marker.position = Vector2(0, -40)
			attack_areaUP.monitoring = true
			attack_areaUP.monitorable = true
			attack_areaUP.visible = true
			anim_sword.play("sword_attack_up")
			print("Atacando arriba")
		FACING.DOWN:
			sword_marker.position = Vector2(0, 40)
			attack_areaDOWN.monitoring = true
			attack_areaDOWN.monitorable = true
			attack_areaDOWN.visible = true
			anim_sword.play("sword_attack_down")
			print("Atacando abajo")
		FACING.LEFT:
			sword_marker.position = Vector2(-30, 0)
			attack_areaLEFT.monitoring = true
			attack_areaLEFT.monitorable = true
			attack_areaLEFT.visible = true
			anim_sword.play("sword_attack_side")
			anim_sword.flip_h = true;
			print("Atacando izquierda")
		FACING.RIGHT:
			sword_marker.position = Vector2(30, 0)
			attack_areaRIGHT.monitoring = true
			attack_areaRIGHT.monitorable = true
			attack_areaRIGHT.visible = true
			anim_sword.play("sword_attack_side")
			anim_sword.flip_h = false;
			print("Atacando derecha")

func reset_state():
	if is_dead:
		return
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

func _on_sword_animation_finished() -> void:
	if anim_sword.animation.begins_with("sword_attack"):
		#print("Fin animación de ataque:", anim_sword.animation)
		reset_state()
	#if anim_sprite2d.animation == "death":
	#	queue_free()

func take_dmg():
	if is_dead:
		return
	hp-= 1 #enemy_ref.strength
	
	#hitbox.monitoring = false
	if hp <= 0:
		print("Muerta")
		set_state(PLAYER_STATE.DEATH)
		#hitbox.monitorable = false
	else:
		set_hit_animation()
	
func death():
	anim_sprite2d.play("death")
	velocity = Vector2.ZERO
	is_dead = true
	hitbox.monitoring = false
	hitbox.monitorable = false
	

func set_hit_animation():
	var tween = create_tween()
	invincible_timer.start()
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)

func _on_hitbox_area_entered(area: Area2D) -> void:
	set_state(PLAYER_STATE.HIT)


func _on_invincible_timer_timeout() -> void:
	reset_state()
	#hitbox.monitoring = true
