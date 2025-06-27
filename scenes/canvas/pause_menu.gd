extends Control

@onready var blur_player = $AnimationPlayer
@onready var resume_button = $MarginContainer/VBoxContainer/ResumeButton

func _ready() -> void:
	blur_player.play("RESET")

func _process(delta: float) -> void:
	testEsc()

func resume():
	get_tree().paused = false
	blur_player.play_backwards("blur")

func pause():
	get_tree().paused = true
	blur_player.play("blur")

func testEsc():
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		resume_button.grab_focus()
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()



func _on_resume_button_pressed() -> void:
	if get_tree().paused:
		resume()

func _on_restart_button_pressed() -> void:
	if get_tree().paused:
		resume()
		GameManager.on_play_game()

func _on_menu_button_pressed() -> void:
	if get_tree().paused:
		resume()
		GameManager.on_main_menu()

func _on_desktop_button_pressed() -> void:
	if get_tree().paused:
		get_tree().quit()
