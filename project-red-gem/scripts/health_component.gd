
extends Node
class_name HealthComponent

@export var max_health: int = 100

var current_health: int

signal health_changed(current_health: int, max_health: int)
signal died

func _ready():
	current_health = max_health
	health_changed.emit(current_health, max_health)

func take_damage(amount: int):
	if current_health <= 0:
		return

	current_health = max(current_health - amount, 0)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		died.emit()

func heal(amount: int):
	if current_health <= 0:
		return

	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func is_dead() -> bool:
	return current_health <= 0
