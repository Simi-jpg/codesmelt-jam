extends CharacterBody2D

@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("player"):
			body.take_damage(10)
		if not body.is_in_group("enemies"):
			queue_free()
	
	move_and_slide()
