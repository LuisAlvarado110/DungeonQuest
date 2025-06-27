extends CharacterBody2D

class_name BaseEnemy

enum ENEMY_STATES {IDLE, RUN, ATTACK, HIT, DEATH}

@export var hp: int = 5
@export var damage: int = 1
@export var movement_speed: int = 15000.0
@export var frame_attack: int

@onready var anim_sprite2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var invicible_timer : Timer = $InvincibleTimer
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_timer: Timer = $AttackTimer
@onready var idle_timer: Timer = $IdleTimer
@onready var hitbox: Area2D = $HitBox
@onready var attack_area: Area2D = $AttackArea
@onready var attack_collision: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var player_ref: Player
@onready var range_area: Area2D = $RangeArea

var direction: Vector2
var previous_state: ENEMY_STATES
var can_attack: bool = true
var bodies
var attack_bodies

var current_state: ENEMY_STATES = ENEMY_STATES.IDLE:
	get:
		return current_state
	set(new_state): 
		if current_state != new_state:
			current_state = new_state

func _ready(): 
	player_ref = get_tree().get_nodes_in_group("player")[0]
	attack_area.visible = false
	attack_area.monitorable = false
	attack_area.monitoring = false


func _physics_process(delta: float) -> void:
	move_and_slide()
	#estas 3 lineas se encargan de revisar si hay cuerpos dentro del area de deteccion
	bodies = range_area.has_overlapping_bodies() 
	if bodies and can_attack and hp > 0 and current_state == ENEMY_STATES.RUN:
		current_state = ENEMY_STATES.ATTACK
		can_attack = false
	
	flip_sprite()
	
	match current_state:
		ENEMY_STATES.IDLE:
			if idle_timer.is_stopped():
				idle_timer.start()
			anim_sprite2d.play("idle")
		ENEMY_STATES.RUN:
			anim_sprite2d.play("run")
			if !idle_timer.is_stopped():
				idle_timer.stop()
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
			reset_attack()

#region funciones encargadas de detalles esteticos
func flip_sprite():
	if velocity.x > 0:
		anim_sprite2d.flip_h = false
	else:
		anim_sprite2d.flip_h = true

#funcion que gira al enemigo si esta quieto
func _on_idle_timer_timeout() -> void:
	anim_sprite2d.flip_h = !anim_sprite2d.flip_h

#endregion

#region funciones encargadas de recibir el golpe
 #funcion que reactiva la hitbox del enemigo despues de la inv
func _on_invincible_timer_timeout() -> void:
	hitbox.monitoring = true
	hitbox.monitorable = true
	if hp > 0:
		current_state = ENEMY_STATES.RUN
		reset_attack()
		can_attack = true
	print("no invisible")

#funcion que desactiva las hitbox del enemigo al recibir daño
func make_invencible():
	invicible_timer.start()
	hitbox.monitoring = false
	hitbox.monitorable = false

#funcion que hace el proceso de recibir daño del enemigo
func receive_attack():
	previous_state = current_state
	if previous_state == ENEMY_STATES.ATTACK: #evita que el enemigo ataque aunque el jugador salga de su area
		previous_state == ENEMY_STATES.RUN
		can_attack = true
	current_state = ENEMY_STATES.HIT
	print(hp)
	#parpadeo en rojo al recibir daño
	var tween = create_tween()
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)

#funcion para cuando un ataque del jugador entre en el area del enemigo
func _on_hit_box_area_entered(area: Area2D) -> void: 
	hp -= player_ref.strenght
	call_deferred("make_invencible") #llama a la funcion hacer invencible un frame despues
	call_deferred("reset_attack") #reinicia los valores de ataque para evitar errores
	if hp <= 0: #cuando la vida llegue a 0 el enemigo morira
		current_state = ENEMY_STATES.DEATH
		anim_sprite2d.play("death")
	else: #cuando el enemigo aun tenga vida llamara a la funcion que e encarga del daño
		call_deferred("receive_attack")
#endregion

#region funciones encargadas del ataque
#señal que se lanza al terminar el timer del cooldown del ataque
func _on_attack_timer_timeout() -> void:
	can_attack = true
	current_state = ENEMY_STATES.RUN

#funcion que revisa si el jugador esta dentro del area del ataque
func player_in_attack_area():
	var player_in_area
	player_in_area = range_area.has_overlapping_bodies() 
	if player_in_area:
		print("jugador golpeado")
		SignalManager.on_enemy_hit.emit(damage)

#funcion que reinicia valores de los ataques
func reset_attack():
	attack_area.visible = false
	attack_area.monitorable = false
	attack_area.monitoring = false
	if hp > 0:
		current_state = ENEMY_STATES.RUN

#endregion

#funcion que se encarga de cambiar al estado correr al detectar al jugador
func _on_detection_area_body_entered(body: Node2D) -> void:
	if hp > 0:
		current_state = ENEMY_STATES.RUN
