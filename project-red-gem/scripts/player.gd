
extends CharacterBody2D

@export var speed: float = 150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health = $HealthComponent

var last_direction: String = "down"

func _ready():
	health.died.connect(_on_died)
	
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)

	velocity = direction * speed
	move_and_slide()

	if direction == Vector2.ZERO:
		animated_sprite.stop()
		return

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			last_direction = "right"
		else:
			last_direction = "left"
	else:
		if direction.y > 0:
			last_direction = "down"
		else:
			last_direction = "up"

	animated_sprite.play(last_direction)
	
	
func _on_died():
	print("DEAD")
