extends Node2D



func game_ending():
	get_tree().change_scene_to_file("res://scenes/level/end.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		game_ending()
