extends CanvasLayer

@onready var food_sprite:TextureRect = $ColorRect/food
@onready var wood_sprite:TextureRect = $ColorRect/wood
@onready var shovel_sprite:TextureRect = $ColorRect/shovel

@onready var progress_bar:Slider = $ColorRect/ProgressBar
@onready var time_label:Label = $ColorRect/Time
@onready var timer:Timer = $"../Timer"

var daylight_duration:float = 10
var start_day_hour:int = 6
var end_day_hour:int = 20

var current_hour: int = 0
var current_minute: int = 0

enum resource_type {food, wood, shovel}

func _ready():
	start_days()

func pick_item(item:resource_type):
	match item:
		resource_type.food:
			food_sprite.modulate.a = 1
		resource_type.wood:
			wood_sprite.modulate.a = 1
		resource_type.shovel:
			shovel_sprite.modulate.a = 1
			
func remove_items():
	food_sprite.modulate.a = 0.5
	wood_sprite.modulate.a = 0.5
	shovel_sprite.modulate.a = 0.5

# Function to start the day simulation
func start_days():
	# Reset timer and start it
	timer.stop()
	timer.wait_time = daylight_duration
	timer.start()

# Connect the timer's "timeout" signal to this function
func update_time_and_progress():
	# Calculate the progress as a percentage
	var progress = 100 -(timer.time_left / daylight_duration) * 100

	# Calculate current hour and minute
	var total_minutes = int(lerp(start_day_hour * 60, end_day_hour * 60, progress / 100))
	current_hour = total_minutes / 60
	current_minute = total_minutes % 60
	
	var am_pm = "am"
	var hour_to_display = current_hour

	if current_hour >= 12:
		am_pm = "pm"
		if current_hour > 12:
			hour_to_display = current_hour - 12

	# Update the label with the current time
	time_label.text = "%02d:%02d %s" % [hour_to_display, current_minute, am_pm]

	# Update the progress bar
	progress_bar.value = progress

	
func _process(delta):
	if timer.is_stopped():
		return
	update_time_and_progress()
