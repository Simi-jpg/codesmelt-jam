
extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var title_label: Label = $TitleLabel
@onready var message_label: Label = $MessageLabel

var message_id: int = 0


func _ready() -> void:
	panel.hide()
	


func show_message(
	title: String,
	message: String,
	duration: float = 5.0
) -> void:
	message_id += 1
	var current_id = message_id

	title_label.text = title
	message_label.text = message

	panel.show()
	title_label.show()
	message_label.show()

	await get_tree().create_timer(duration).timeout

	title_label.hide()
	message_label.hide()
	
	# Prevent an older timer from hiding a newer message
	if current_id == message_id:
		panel.hide()
