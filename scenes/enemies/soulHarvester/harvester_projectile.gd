extends Area2D

var direction = Vector2.UP
var bullet_speed = 500.0
var damage:int = 2

func set_direction(new_angle : Vector2):
	direction = new_angle.normalized()

func _process(delta: float) -> void:
	position += direction * bullet_speed * delta

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	SignalManager.on_enemy_hit.emit(damage)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
