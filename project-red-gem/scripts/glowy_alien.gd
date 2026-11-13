extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"

@export var speed: float = 100.0

func _physics_process(delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
