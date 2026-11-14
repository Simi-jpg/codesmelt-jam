extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var health: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@export var knockback_force: float = 250.0
@export var knockback_friction: float = 1000.0
@export var stop_distance: float = 20.0
var knockback_velocity: Vector2 = Vector2.ZERO
@export var speed: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = $Glowy
const PROJECTILE = preload("uid://2b42eydfvrtl")
var idle = true
var in_attack_range = false
var can_shoot = true

func _ready() -> void:
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	health_bar.hide()
	
func _physics_process(delta):
	if player:
		if not idle and global_position.distance_to(player.global_position) > stop_distance:
			var direction = global_position.direction_to(player.global_position)
			# follow player
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * delta)
		move_and_slide()
		update_animation()
		
		if in_attack_range and can_shoot:
			shoot()
		
func take_damage(amount: int):
	var knockback_direction = global_position.direction_to(player.global_position)
	knockback_velocity = -knockback_direction * knockback_force
	health.take_damage(amount)

func _on_died():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.15)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.2)

	tween.tween_callback(queue_free)

	
func _on_health_changed(current_health: int, max_health: int):
	health_bar.max_value = max_health
	health_bar.value = current_health

func update_animation():
	if abs(velocity.x) < 1.0:
		animated_sprite.play("idle")
	elif velocity.x < 0:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("move_right")
	
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		health_bar.show()
		idle = false
		in_attack_range = true

func shoot():
	can_shoot = false
	var projectile = PROJECTILE.instantiate()
	get_tree().current_scene.call_deferred("add_child", projectile)
	projectile.global_position = global_position
	
	# Ignore the enemy that shot it
	projectile.add_collision_exception_with(self)
	
	var direction = global_position.direction_to(player.global_position)
	projectile.direction = direction
	await get_tree().create_timer(2.0).timeout
	can_shoot = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_attack_range = false
		health_bar.hide()
