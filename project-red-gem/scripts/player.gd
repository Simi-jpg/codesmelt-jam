
extends CharacterBody2D

@export var speed: float = 150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@export var attack_damage: int = 10
@onready var pivot: Node2D = $Pivot
@onready var swing: Node2D = $Pivot/Swing
@onready var sword: Sprite2D = $Pivot/Swing/Sword
@onready var attack_area: Area2D = $Pivot/Swing/Sword/AttackArea

var attacking = false
var last_direction: String = "down"

#var enemies_in_range: Array[Node2D] = []

func _ready():
	attack_area.monitoring = false
	sword.visible = false
	health.died.connect(_on_died)
	health.health_changed.connect(_on_health_changed)
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health

func _on_health_changed(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health

func _input(event):
	if not attacking and Input.is_action_just_pressed("attack"):
		attack()
	
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)
	if direction != Vector2.ZERO:
		pivot.rotation = direction.angle()
	
	if not attacking:
		velocity = direction * speed

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
	else:
		velocity = Vector2.ZERO

	animated_sprite.play(last_direction)
	move_and_slide()
	
 
func _on_died():
	print("DEAD")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(10)
func take_damage(amount: int):
	health.take_damage(amount)
func attack() -> void:
	if attacking:
		return
	attack_area.monitoring = true
	attacking = true
	sword.visible = true
	var tween = create_tween()
	
	swing.rotation_degrees = -60
	
	tween.tween_property(
		swing,
		"rotation_degrees",
		60,
		0.2
	)
	tween.tween_callback(func():
		attack_area.monitoring = false
		sword.visible = false
		attacking = false
		swing.rotation_degrees = 0
		)
