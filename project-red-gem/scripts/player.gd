
extends CharacterBody2D

@export var speed: float = 150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar

var last_direction: String = "down"

func _ready():
	health.died.connect(_on_died)
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health

	
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)
	
	if Input.is_action_just_pressed("ui_accept"):
		health.take_damage(10)
		health_bar.value = health.current_health

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
