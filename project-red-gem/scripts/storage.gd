extends Node2D

@onready var message = $Message
@onready var security_terminal = $SecurityTerminal
@onready var reactor_pulse = $ReactorPulse
@onready var walls: TileMapLayer = $TileMapLayer
@onready var key = $StaticBody2D/KeyBig


var terminal_repaired: bool = false
var reactor_repaired: bool = false
var player_near_chest: bool = false
var has_key: bool = false



func _ready() -> void:
	
	key.hide()
	
	security_terminal.repaired.connect(_on_terminal_repaired)
	reactor_pulse.repaired.connect(_on_reactor_repaired)

	message.show_message(
		"SYSTEM MALFUNCTION",
		"Repair the security terminal and stabilize the reactor.",
		6.0
	)


func _on_terminal_repaired() -> void:
	terminal_repaired = true

	message.show_message(
		"SECURITY RESTORED",
		"Security terminal is now operational.",
		4.0
	)

	check_quests_completed()


func _on_reactor_repaired() -> void:
	reactor_repaired = true

	message.show_message(
		"REACTOR STABILIZED",
		"Reactor pulse has been restored.",
		4.0
	)

	check_quests_completed()


func check_quests_completed() -> void:
	if terminal_repaired and reactor_repaired:
		
		open_passage()
		
		message.show_message(
			"SYSTEMS ONLINE",
			"All storage room systems restored. Access granted.",
			6.0
		)

func open_passage() -> void:
	var source_id = walls.get_cell_source_id(Vector2i(27, 35))
	var atlas_coords = walls.get_cell_atlas_coords(Vector2i(27, 35))
	var alternative = walls.get_cell_alternative_tile(Vector2i(27, 35))

	for x in range(28, 30):
		for y in range(35, 39):
			walls.set_cell(
				Vector2i(x, y),
				source_id,
				atlas_coords,
				alternative
			)
			
			
			

	
	
	
		
		
func _unhandled_key_input(event):
	if not event.pressed or event.echo:
		return

	if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
		if player_near_chest and not has_key:
			has_key = true
			key.show()

			$Message.show_message(
				"KEY RETRIEVED",
				"Press M to enter the next room.",
				5.0
			)

	elif event.keycode == KEY_M and has_key:
		get_tree().change_scene_to_file("res://scenes/level/dark.tscn")


func _on_key_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near_chest = true
		
		if not has_key:
			message.show_message(
				"CHEST FOUND",
				"Press Enter to retrieve the key from the chest",
				3.0
			)


func _on_key_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near_chest = false
