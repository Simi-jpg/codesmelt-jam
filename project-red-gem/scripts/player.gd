
extends CharacterBody2D

@export var speed: float = 150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@export var attack_damage: int = 10
@onready var pivot: Node2D = $Pivot
@onready var swing: Node2D = $Pivot/Swing
@onready var sword: Sprite2D = $Pivot/Swing/Sword

var attacking = false
var last_direction: String = "down"

var enemies_in_range: Array[Node2D] = []

func _ready():
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

	if Input.is_action_just_pressed("ui_accept"):
		health.take_damage(10)
		health_bar.value = health.current_health
	
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
		enemies_in_range.append(body)

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)


func attack() -> void:
	if attacking:
		return
	
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
		sword.visible = false
		attacking = false
		swing.rotation_degrees = 0
		)
	if enemies_in_range.is_empty():
		return

	var enemy = enemies_in_range[0]

	if is_instance_valid(enemy):
		if enemy.has_method("take_damage"):
			enemy.take_damage(10)
