# extend the Button itself
extends Button

func _ready() -> void:
	# connect to yourself
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# hide the parent overlay
	get_parent().get_parent().get_parent().hide()
	# (or emit a signal back up to the overlay)
