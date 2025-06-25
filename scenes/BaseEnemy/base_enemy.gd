extends CharacterBody2D

class_name BaseEnemy

enum ENEMY_STATES {IDLE, RUN, ATTACK, HIT, DEATH}

@export var hp: int = 5
@export var damage: int = 1
@export var movement_speed: int = 1000.0

@onready var anim_sprite2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var hitbox: Area2D = $HitBox
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var patrol_timer: Timer = $PatrolTimer
@onready var player_ref: Player
@onready var invicible_timer : Timer = $InvincibleTimer

var previous_state: ENEMY_STATES
var direction: Vector2

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
	match current_state:
		ENEMY_STATES.IDLE:
			anim_sprite2d.play("idle")
			print("IDLE")
		ENEMY_STATES.RUN:
			print("RUN")
		ENEMY_STATES.ATTACK:
			print("ATTACK")
		ENEMY_STATES.HIT:
			anim_sprite2d.play("hit")
			print("HIT")
		ENEMY_STATES.DEATH:
			anim_sprite2d.play("death")
			print("DEATH")
	
	
	velocity = delta * movement_speed * direction
	flip_sprite()

func flip_sprite():
	if velocity.x > 0:
		anim_sprite2d.flip_h = false 
	else:
		anim_sprite2d.flip_h = true

func make_invencible():
	hitbox.monitoring = false
	hitbox.monitorable = false

func receive_attack():
	previous_state = current_state
	current_state = ENEMY_STATES.HIT
	var tween = create_tween()
	invicible_timer.start()
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,0,0),0.25)
	tween.tween_property(anim_sprite2d,"self_modulate", Color(1,1,1),0.25)

func _on_animated_sprite_2d_animation_finished() -> void:
	match anim_sprite2d.animation:
		"death": #cuando la animacion llamada death termine los enemigos desapareceran
			queue_free()
		"hit":
			current_state = previous_state

func _on_invincible_timer_timeout() -> void: #funcion que reactiva la hitbox del enemigo despues de la inv
	hitbox.monitoring = true
	hitbox.monitorable = true
	print("no invisible")

func _on_hit_box_area_entered(area: Area2D) -> void: #funcion para cuando un ataque del jugador entre en el area del enemigo
	hp -= player_ref.strenght
	print("enemigo hit")
	call_deferred("make_invencible")
	if hp <= 0: #cuando la vida llegue a 0
		print("enemigo muerto")
		current_state = ENEMY_STATES.DEATH
		velocity = Vector2.ZERO
	else: #cuando el enemigo aun tenga vida
		print("invencible")
		call_deferred("receive_attack")




func _on_detection_area_body_entered(body: Node2D) -> void:
	print("jugador detectado")
	current_state = ENEMY_STATES.RUN
