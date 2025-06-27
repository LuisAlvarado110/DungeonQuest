extends CanvasLayer

func _ready() -> void:
	SignalManager.on_player_death.connect(on_death_player)

func on_death_player():
	pass

func _on_menu_btn_pressed() -> void:
	pass # Replace with function body.


func _on_exit_btn_pressed() -> void:
	GameManager.on_exit()
