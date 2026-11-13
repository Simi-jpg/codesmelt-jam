
extends Node2D

var swinging = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			swing()

func swing():
	if swinging:
		return

	swinging = true

	rotation_degrees = -90
	var tween = create_tween()


	tween.tween_property(self, "rotation_degrees", 90, 0.15)
	tween.tween_property(self, "rotation_degrees", 0, 0.15)

	tween.finished.connect(func():
		swinging = false
	)
