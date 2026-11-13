extends ProgressBar

@onready var health_component: HealthComponent = $"../HealthComponent"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = health_component.current_health

func
