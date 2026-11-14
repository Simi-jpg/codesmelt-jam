extends Node2D

var in_range = false
@onready var alarm_lights: Node2D = $AlarmLights
@onready var label: Label = $CanvasLayer/Label
@onready var countdown: Label = $CanvasLayer/Countdown
@onready var enemy_spawner: Node2D = $EnemySpawner
var alarm_disabled = false
@onready var timer: Timer = $Timer

func _process(delta: float) -> void:
	countdown.text = "Alarm disabling: " + str (int(timer.time_left))
	print(timer.time_left)
	
func _input(event):
	if Input.is_key_pressed(KEY_R):
		start_timer()
	if Input.is_key_pressed(KEY_M) and alarm_disabled:
		get_tree().change_scene_to_file("res://scenes/level/cockpit.tscn")

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
	label.show()
	label.text = "Press M to enter the cockpit"
	alarm_lights.visible = false
	alarm_disabled = true
	countdown.visible = false
	enemy_spawner.queue_free()
