extends Node

signal key_collected_signal

@onready var fridge_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var key: Sprite2D = $Key

var key_available = false
var key_collected = false

var player_near = false
var opened = false

func _ready():
	opened = false
	player_near = false
	fridge_sprite.play("fridge_close")

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):
		if not opened:
			fridge_sprite.play("fridge_open")
			opened = true

			key.visible = true
			key_available = true

			key.position.y += 20

			var tween = create_tween()
			tween.tween_property(key, "position:y", key.position.y + 30, 0.5)
	if key_available and not key_collected and Input.is_key_pressed(KEY_F):
		key_collected = true
		key_available = false
		key.visible = false
		print("KEY COLLECTED!")
		key_collected_signal.emit()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_near = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_near = false
		if opened:
			fridge_sprite.play("fridge_close")
			opened = false
