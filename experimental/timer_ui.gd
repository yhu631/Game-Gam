extends Node

@export var max_time: float = 60.0  # total countdown in seconds

var time_left: float
var original_position: Vector2

@onready var bar: TextureProgressBar = $CanvasLayer/ThermometerBar
@onready var time_label: Label      = $CanvasLayer/ThermometerBar/TimeLabel

func _ready() -> void:
	# 1) Enable per-frame _process() calls
	set_process(true)

	# 2) Init timer and record original bar position
	time_left = max_time
	original_position = bar.position

	# 3) Configure bar: full-range + no snapping
	bar.min_value = 0.0
	bar.max_value = max_time
	bar.step      = 0.0

	# 4) Sync UI immediately
	_update_ui()

func _process(delta: float) -> void:
	if time_left > 0.0:
		time_left = max(time_left - delta, 0.0)
		if time_left == 0.0:
			end_game()
	
	_update_ui()
	_update_shake()

func _update_ui() -> void:
	# Fill from 0→max_time
	bar.value = max_time - time_left
	time_label.text = "%.2f" % time_left
	
	# Color change based on heat
	var heat_ratio = (max_time - time_left) / max_time
	if heat_ratio < 0.7:
		bar.tint_progress = Color(1, 0, 0)
	elif heat_ratio < 0.9:
		bar.tint_progress = Color(0.8, 0, 0)
	else:
		bar.tint_progress = Color(0.6, 0, 0)

func _update_shake() -> void:
	var ratio: float = bar.value / max_time
	if ratio >= 0.7:
		# Python-style inline if … else for GDScript (no '?:')
		var strength: float = 2.5 if ratio >= 0.9 else 1.0
		bar.position = original_position + Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
	else:
		bar.position = original_position

func end_game() -> void:
	print("Time’s up!")
	get_tree().paused = true
	# e.g. get_tree().change_scene_to_file("res://GameOver.tscn")
