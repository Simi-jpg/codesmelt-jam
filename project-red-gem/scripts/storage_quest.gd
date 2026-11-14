extends Area2D

@export var offline_animation: StringName = &"offline"
@export var repair_animation: StringName = &"repair"

signal repaired

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_label: Label = $Label

var player_nearby: bool = false
var is_repaired: bool = false


func _ready() -> void:
	sprite.play(offline_animation)
	interaction_label.hide()

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if player_nearby and not is_repaired:
		if Input.is_key_pressed(KEY_R):
			repair_terminal()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		if not is_repaired:
			interaction_label.show()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		interaction_label.hide()


func repair_terminal() -> void:
	is_repaired = true
	interaction_label.hide()

	for i in range(5):
		sprite.play(repair_animation)
		await sprite.animation_finished
		sprite.stop()
		sprite.frame = 0

	# Leave the terminal on its final frame
	sprite.frame = 3

	repaired.emit()
