extends Node2D

var in_range = false
@onready var alarm_lights: Node2D = $AlarmLights
@onready var label: Label = $CanvasLayer/Label
@onready var countdown: Label = $CanvasLayer/Countdown
@onready var enemy_spawner: Node2D = $EnemySpawner

@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	countdown.text = "Alarm disabling: " + str (int(timer.time_left))
	print(timer.time_left)
	
func _input(event):
	if Input.is_key_pressed(KEY_R):
		start_timer()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		label.show()
func start_timer():
	countdown.visible = true
	timer.start()
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false
	label.hide()


func _on_timer_timeout() -> void:
	alarm_lights.visible = false
	countdown.visible = false
	enemy_spawner.queue_free()
