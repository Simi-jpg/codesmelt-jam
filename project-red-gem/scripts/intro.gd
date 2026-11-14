extends Control

@onready var planet = $Planet
@onready var alien_ship = $AlienShip
@onready var player_ship = $PlayerShip
@onready var story_text = $StoryLine
@onready var enter_prompt = $StartGame

var intro_finished = false


func _ready() -> void:
	alien_ship.hide()
	enter_prompt.hide()
	play_intro()
	Global.hide_label()


func play_intro() -> void:
	# Part 1: The mission
	story_text.text = "Your home planet is dying.\nOnly a rare gem can save it."
	await get_tree().create_timer(4.0).timeout

	story_text.text = "The gem's signal was last detected near the Veyra Star.\nYour ship has been sent to retrieve it."
	await get_tree().create_timer(4.0).timeout

	# Part 2: Travel toward the star
	story_text.text = "Autopilot engaged. Destination: Veyra Star."

	var flight = create_tween()
	flight.tween_property(
		player_ship,
		"position",
		Vector2(player_ship.position.x, player_ship.position.y - 300),
		10.0
	)

	await flight.finished
	
	# Part 3: A new signal
	story_text.text = "WARNING: Stronger gem signal detected elsewhere.\nChanging course..."
	await get_tree().create_timer(3.0).timeout

	# Rotate 90 degrees clockwise
	var turn = create_tween()
	turn.set_parallel(true)
	
	turn.tween_property(
		player_ship,
		"rotation_degrees",
		player_ship.rotation_degrees + 90,
		1.0
	)
	
	turn.tween_property(player_ship, "position", player_ship.position
	+ Vector2(100, -100), 1.0)
	
	await turn.finished
	
	# Part 4: Travel in the new direction for 10 seconds
	story_text.text = "Following the new signal..."

	var travel = create_tween()
	travel.tween_property(
		player_ship,
		"position:x",
		player_ship.position.x + 350,
		15.0
	)
	
	var move_back = create_tween()
	move_back.tween_property(planet,"position:x",
	 planet.position.x -350, 15.0)


	await travel.finished

	# The alien ship appears
	alien_ship.position = Vector2(960, 40)
	alien_ship.show()

	story_text.text = "An enormous alien vessel detected!\nThe gem's signal is coming from inside."

	# Approach the alien ship over 5 seconds
	var approach = create_tween()
	approach.tween_property(
		player_ship,
		"position:x",
		alien_ship.position.x + 30,
		8.0)
		
		#move the alien ship back 
	var back = create_tween()
	back.tween_property(alien_ship, "position:x", alien_ship.position.x - 120, 6)

	await approach.finished


	# Part 5: Board
	story_text.text = "The gem is somewhere inside this ship."
	enter_prompt.text = "PRESS ENTER TO BOARD"
	enter_prompt.show()
	intro_finished = true


func _unhandled_key_input(event: InputEvent) -> void:
	if not intro_finished:
		return

	if event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			Global.show_label()
			get_tree().change_scene_to_file(
                "res://scenes/level/storage.tscn"
			)
