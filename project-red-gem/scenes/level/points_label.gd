extends Label

func _ready():
	text = "You earned " + str(Global.get_points()) + " points"
