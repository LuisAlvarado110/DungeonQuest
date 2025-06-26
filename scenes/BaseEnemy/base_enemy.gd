extends CharacterBody2D

class_name BaseEnemy

enum ENEMY_STATES {IDLE, RUN, ATTACK, HIT, DEATH}

@export var hp: int = 5
@export var damage: int = 1
@export var movement_speed: int = 15000.0

@onready var anim_sprite2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var invicible_timer : Timer = $InvincibleTimer
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_timer: Timer = $AttackTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var hitbox: Area2D = $HitBox
@onready var player_ref: Player
@onready var range_area: Area2D = $RangeArea



var direction: Vector2
var previous_state: ENEMY_STATES
var can_attack: bool = true
var bodies

var current_state: ENEMY_STATES = ENEMY_STATES.IDLE:
	get:
		return current_state
	set(new_state): 
		if current_state != new_state:
			current_state = new_state

func _ready(): 
	player_ref = get_tree().get_nodes_in_group("player")[0]


func _physics_process(delta: float) -> void:
	move_and_slide()
	#estas 3 lineas se encargan de revisar si hay cuerpos dentro del area de deteccion
	bodies = range_area.has_overlapping_bodies() 
	if bodies and can_attack and hp > 0 and current_state == ENEMY_STATES.RUN:
		current_state = ENEMY_STATES.ATTACK
	
	flip_sprite()
	
	match current_state:
		ENEMY_STATES.IDLE:
			if idle_timer.is_stopped():
				idle_timer.start()
			anim_sprite2d.play("idle")
			print("IDLE")
		ENEMY_STATES.RUN:
			anim_sprite2d.play("run")
			if !idle_timer.is_stopped():
				idle_timer.stop()
			print("RUN")
			nav_agent.target_position = player_ref.global_position
			direction = to_local(nav_agent.get_next_path_position()).normalized()
		ENEMY_STATES.ATTACK:
			anim_sprite2d.flip_h = player_ref.global_position.x < global_position.x
			anim_sprite2d.play("attack")
		ENEMY_STATES.HIT:
			anim_sprite2d.play("hit")
		ENEMY_STATES.DEATH:
			anim_sprite2d.play("death")
	
	if !invicible_timer.is_stopped() or current_state == ENEMY_STATES.ATTACK:
		direction = Vector2.ZERO
	velocity = delta * movement_speed * direction
	

func _on_animated_sprite_2d_animation_finished() -> void:
	match anim_sprite2d.animation:
		"death": #cuando la animacion llamada death termine los enemigos desapareceran
			queue_free()
		"attack":
			print("ataque terminado")
			attack_timer.start()
			can_attack = true
			current_state = ENEMY_STATES.RUN

#region funciones encargadas de solucionar detalles
func flip_sprite():
	if velocity.x > 0:
		anim_sprite2d.flip_h = false 
	else:
		anim_sprite2d.flip_h = true

func _on_idle_timer_timeout() -> void:
	anim_sprite2d.flip_h = !anim_sprite2d.flip_h
	print("Girar")

func reset_states():
	can_attack = true

#endregion


#region funciones encargadas de recibir el golpe
func _on_invincible_timer_timeout() -> void: #funcion que reactiva la hitbox del enemigo despues de la inv
	hitbox.monitoring = true
	hitbox.monitorable = true
	if hp > 0:
		current_state = ENEMY_STATES.RUN
	print("no invisible")

func make_invencible():
	invicible_timer.start()
	hitbox.monitoring = false
	hitbox.monitorable = false

func receive_attack():
	previous_state = current_state
	if previous_state == ENEMY_STATES.ATTACK:
		previous_state == ENEMY_STATES.RUN
	current_state = ENEMY_STATES.HIT
	var tween = create_tween()
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)

func _on_hit_box_area_entered(area: Area2D) -> void: #funcion para cuando un ataque del jugador entre en el area del enemigo
	hp -= player_ref.strenght
	call_deferred("make_invencible")
	if hp <= 0: #cuando la vida llegue a 0
		current_state = ENEMY_STATES.DEATH
		anim_sprite2d.play("death")
	else: #cuando el enemigo aun tenga vida
		call_deferred("receive_attack")
#endregion


#region funciones encargadas del ataque
func _on_attack_timer_timeout() -> void:
	can_attack = true



#endregion

#funcion que se encarga de cambiar al estado correr al detectar al jugador
func _on_detection_area_body_entered(body: Node2D) -> void:
	current_state = ENEMY_STATES.RUN
