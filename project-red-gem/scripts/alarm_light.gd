extends PointLight2D

@export var min_energy: float = 0.04
@export var max_energy: float = 0.5
@export var pulse_speed: float = 1.0

func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(self, "energy", max_energy, pulse_speed)
	tween.tween_property(self, "energy", min_energy, pulse_speed)
