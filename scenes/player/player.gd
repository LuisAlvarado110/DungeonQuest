extends CharacterBody2D

enum FACING {UP, DOWN, LEFT, RIGHT}

@onready var anim_sprite2d = $AnimatedSprite2D

@export var move_spd = 15000;
var facing_direction: FACING = FACING.UP
var is_moving: bool = false

func _physics_process(delta: float) -> void:
	player_input(delta)
	set_animation()
	move_and_slide()

func player_input(delta: float):
	var h_move = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var v_move = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	velocity.x = move_spd * h_move * delta
	velocity.y = move_spd * v_move * delta
	
	if (h_move != 0 and v_move != 0):
		velocity /= sqrt(2)

func set_animation():
	if (velocity.length() == 0):
		anim_sprite2d.stop()
		return
	
	if (abs(velocity.x) > abs(velocity.y)):
		if (velocity.x != 0):
			if (velocity.x < 0):
				facing_direction = FACING.LEFT
				anim_sprite2d.play("walk_side")
				anim_sprite2d.flip_h = true;
			else:
				facing_direction = FACING.RIGHT
				anim_sprite2d.play("walk_side")
				anim_sprite2d.flip_h = false;
	else:
		if (velocity.y != 0):
			if (velocity.y < 0):
				facing_direction = FACING.UP
				anim_sprite2d.play("walk_up")
			else:
				facing_direction = FACING.DOWN
				anim_sprite2d.play("walk_down")
