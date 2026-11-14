
extends Node2D

@export var spawn_scene: PackedScene
@export var spawn_interval: float = 60.0
@export var max_active: int = 3
@export var spawn_on_start: bool = false

@onready var timer: Timer = $Timer
@onready var spawn_points: Node2D = $SpawnPoints

var active_objects: Array[Node2D] = []


func _ready() -> void:
	timer.wait_time = maxf(spawn_interval, 0.01)
	timer.timeout.connect(spawn_object)

	if spawn_on_start:
		spawn_object()

	timer.start()


func spawn_object() -> void:
	if spawn_scene == null:
		return

	# Remove references to collected or destroyed objects
	active_objects = active_objects.filter(
		func(obj): return is_instance_valid(obj) and not obj.is_queued_for_deletion()
	)

	if active_objects.size() >= max_active:
		return

	var points = spawn_points.get_children()

	if points.is_empty():
		return

	var available_points = []

	for point in points:
		if not point is Marker2D:
			continue

		var occupied = false

		for obj in active_objects:
			if obj.global_position.distance_to(point.global_position) < 16.0:
				occupied = true
				break

		if not occupied:
			available_points.append(point)

	if available_points.is_empty():
		return

	var chosen_point = available_points.pick_random()
	var obj = spawn_scene.instantiate()

	if not obj is Node2D:
		push_warning("Spawned scene must have a Node2D root.")
		obj.free()
		return

	get_tree().current_scene.add_child.call_deferred(obj)
	obj.global_position = chosen_point.global_position

	active_objects.append(obj)
