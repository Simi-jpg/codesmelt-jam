extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"
@onready var health: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar

@export var speed: float = 100.0

func _ready() -> void:
	health.health_changed.connect(_on_health_changed)
	health.died.connect(_on_died)
	health_bar.max_value = health.max_health
	health_bar.value = health.current_health
	
func _physics_process(delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
func take_damage(amount: int):
	health.take_damage(amount)
	
func _on_died():
	queue_free()
	
func _on_health_changed(current_health: int, max_health: int):
	health_bar.max_value = max_health
	health_bar.value = current_health
