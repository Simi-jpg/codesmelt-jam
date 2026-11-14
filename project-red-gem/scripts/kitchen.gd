extends Node

@onready var main_door = $Door/AnimatedSprite2D
@onready var exit_door = $ExitDoor/AnimatedSprite2D
@onready var fridge = $Fridge
@onready var message = $Message


func _ready():
	main_door.play("door_close")
	exit_door.frame = 3
	fridge.key_collected_signal.connect(_on_key_collected)
	message.show_message("Congrats for making it throught the first level!",
	 "Your next task is to fight the aliens and interact with the furniture to find the key that will open the door to the next level!", 10.0)
	
func _on_key_collected():
	exit_door.play("door_open")
