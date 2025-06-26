extends CanvasLayer

@onready var sprite_hp = $MarginContainer/SpriteHP

var hp_value_0 = load("res://assets/life_hp/hp_values/HP_Value_0.png")
var hp_value_1 = load("res://assets/life_hp/hp_values/HP_Value_1.png")
var hp_value_2 = load("res://assets/life_hp/hp_values/HP_Value_2.png")
var hp_value_3 = load("res://assets/life_hp/hp_values/HP_Value_3.png")
var hp_value_4 = load("res://assets/life_hp/hp_values/HP_Value_4.png")
var hp_value_5 = load("res://assets/life_hp/hp_values/HP_Value_5.png")

func _ready() -> void:
	SignalManager.on_hp_update.connect(update_hp)

func update_hp(hp_player: int):
	match hp_player:
		5:
			sprite_hp.texture = hp_value_5
		4:
			sprite_hp.texture = hp_value_4
		3:
			sprite_hp.texture = hp_value_3
		2:
			sprite_hp.texture = hp_value_2
		1:
			sprite_hp.texture = hp_value_1
		0:
			sprite_hp.texture = hp_value_0
