extends MarginContainer



func _ready() -> void:
	pass

func _on_lvl_gt_button_pressed() -> void:
	GameManager.on_lvl_tst()

func _on_lvl_temp_button_pressed() -> void:
	GameManager.on_lvl_tmp()

func _on_exit_button_pressed() -> void:
	GameManager.on_exit()
