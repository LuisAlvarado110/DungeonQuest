extends CharacterBody2D

@export var speed := 300.0
var direction := Vector2.ZERO
var is_charging := false

func _ready():
	$Area2D_Right.connect("body_entered", _on_area_entered.bind(Vector2.RIGHT))
	$Area2D_Left.connect("body_entered", _on_area_entered.bind(Vector2.LEFT))
	$Area2D_Up.connect("body_entered", _on_area_entered.bind(Vector2.UP))
	$Area2D_Down.connect("body_entered", _on_area_entered.bind(Vector2.DOWN))

func _on_area_entered(body: Node, dir: Vector2):
	if is_charging or body.name != "Player":
		return
	direction = dir
	is_charging = true

func _physics_process(delta):
	if is_charging:
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
