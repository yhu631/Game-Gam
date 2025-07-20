extends Node

# Time limit and remaining time in seconds
var max_time := 60.0
var time_left := 60.0
var shake_timer = 0.0
var original_position := Vector2.ZERO  # Store the default UI position

@onready var thermometer = $CanvasLayer/ThermometerBar
@onready var timer_label = $CanvasLayer/ThermometerBar/TimerLabel

func _ready():
	original_position = thermometer.position  # Capture initial (top-right) position

func _process(delta):
	# print("Time:", time_left, "Fill:", thermometer.value)
	
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			end_game()
		
		# Calculate how "hot" the thermometer should be
		var fill_ratio = 1.0 - (time_left / max_time)
		thermometer.value = fill_ratio * thermometer.max_value
		
		# Round remaining time to 2 decimal places
		timer_label.text = "%.2f" % time_left
		
	# Color change based on heat
	var heat_ratio = (max_time - time_left) / max_time
	if heat_ratio < 0.7:
		thermometer.tint_progress = Color(1, 0, 0)
	elif heat_ratio < 0.9:
		thermometer.tint_progress = Color(0.8, 0, 0)
	else:
		thermometer.tint_progress = Color(0.6, 0, 0)
		
	# Animation based on heat
	var shake_ratio = thermometer.value / thermometer.max_value

	if shake_ratio >= 0.7:
		shake_timer += delta
		var shake_strength = 1.0
		
		if shake_ratio >= 0.9:
			shake_strength = 2.5
			
		var offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		thermometer.position = original_position + offset
	else:
		thermometer.position = original_position  # Reset to top-right corner
	
func end_game():
	print("Time's up!")
	get_tree().paused = true
	# Switch scene to game over menu
