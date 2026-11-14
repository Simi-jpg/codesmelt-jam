extends CanvasLayer

var points: int = 0

@onready var points_label = $PointsLabel

func _ready() -> void:
	update_points_ui()

func add_points(amount: int):
	points += amount
	update_points_ui()
func get_points():
	return points
func reset_points():
	points = 0
	
func update_points_ui():
	points_label.text = "Points: " + str(points)
