extends Node

@onready var main_door = $Door/AnimatedSprite2D
@onready var exit_door = $ExitDoor/AnimatedSprite2D
@onready var fridge = $Fridge



func _ready():
	main_door.play("door_close")
	exit_door.frame = 3
	fridge.key_collected_signal.connect(_on_key_collected)
	
func _on_key_collected():
	exit_door.play("door_open")
