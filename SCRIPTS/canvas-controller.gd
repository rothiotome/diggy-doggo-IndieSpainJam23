extends CanvasLayer

@onready var food_sprite:TextureRect = $ColorRect/food
@onready var wood_sprite:TextureRect = $ColorRect/wood
@onready var shovel_sprite:TextureRect = $ColorRect/shovel

@onready var progress_bar:Slider = $ColorRect/ProgressBar
@onready var time_label:Label = $ColorRect/Time
@onready var timer:Timer = $"../DaylightTimer"

var start_day_hour:int = 6
var end_day_hour:int = 20

var current_hour: int = 0
var current_minute: int = 0

func pick_item(item:Pickable.resource_type):
	match item:
		Pickable.resource_type.food:
			food_sprite.modulate.a = 1
		Pickable.resource_type.wood:
			wood_sprite.modulate.a = 1
		Pickable.resource_type.shovel:
			shovel_sprite.modulate.a = 1
			
func remove_items():
	food_sprite.modulate.a = 0.25
	wood_sprite.modulate.a = 0.25
	shovel_sprite.modulate.a = 0.25
	

func update_time_and_progress():
	var progress = 100 -(timer.time_left / Globals.current_daylight_duration) * 100

	var total_minutes = int(lerp(start_day_hour * 60, end_day_hour * 60, progress / 100))
	current_hour = total_minutes / 60
	current_minute = total_minutes % 60
	
	var am_pm = "am"
	var hour_to_display = current_hour

	if current_hour >= 12:
		am_pm = "pm"
		if current_hour > 12:
			hour_to_display = current_hour - 12

	time_label.text = "%02d:%02d %s" % [hour_to_display, current_minute, am_pm]

	progress_bar.value = progress

	
func _process(delta):
	if timer.is_stopped():
		return
	update_time_and_progress()
