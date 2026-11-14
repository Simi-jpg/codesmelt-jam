extends Node2D
@onready var label: Label = $CanvasLayer/Label


func _input(event):
	if Input.is_key_pressed(KEY_M):
		get_tree().change_scene_to_file("res://scenes/level/dark-survival.tscn")


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		label.show()
