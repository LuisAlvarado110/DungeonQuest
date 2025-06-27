extends CanvasLayer

@onready var anim_player = $AnimationPlayer
@onready var game_over_label = $%GameOver
@onready var menu_btn = $%MenuBtn
@onready var exit_btn = $%ExitBtn

func _ready() -> void:
	visible = false
	menu_btn.visible = false
	exit_btn.visible = false
	SignalManager.on_player_death.connect(on_death_player)

func on_death_player():
	get_tree().paused = false
	visible = true
	anim_player.play("game_over_anim")
	menu_btn.visible = true
	exit_btn.visible = true

func _on_menu_btn_pressed() -> void:
	GameManager.on_main_menu()


func _on_exit_btn_pressed() -> void:
	GameManager.on_exit()
