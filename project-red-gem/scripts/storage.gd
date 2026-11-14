extends Node2D

@onready var message = $Message
@onready var security_terminal = $SecurityTerminal
@onready var reactor_pulse = $ReactorPulse
@onready var walls: TileMapLayer = $TileMapLayer

var terminal_repaired: bool = false
var reactor_repaired: bool = false


func _ready() -> void:
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
