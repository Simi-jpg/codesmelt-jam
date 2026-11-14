
extends Area2D

@export var heal_amount: int = 25

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var health_component = body.get_node_or_null("HealthComponent")

	if health_component == null:
		return

	if health_component.current_health >= health_component.max_health:
		return

	health_component.heal(heal_amount)
	queue_free()
