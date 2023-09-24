extends CanvasLayer

class_name canvas_controller

@onready var food_sprite:TextureRect = $ColorRect/food_parent/food
@onready var wood_sprite:TextureRect = $ColorRect/wood_parent/wood
@onready var shovel_sprite:TextureRect = $ColorRect/shovel_parent/shovel

@onready var progress_bar:Slider = $ColorRect/ProgressBar
@onready var time_label:Label = $ColorRect/Time
@onready var timer:Timer = $"../DaylightTimer"

@onready var message_panel = $message_panel

var start_day_hour:int = 6
var end_day_hour:int = 20

var current_hour: int = 0
var current_minute: int = 0

signal on_message_closed

func _process(_delta):
	if timer.is_stopped():
		return
	update_time_and_progress()

func _ready():
	message_panel.connect("on_message_closed", message_closed)

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

func remove_item(item:Pickable.resource_type):
		match item:
			Pickable.resource_type.food:
				food_sprite.modulate.a = 0.25
			Pickable.resource_type.wood:
				wood_sprite.modulate.a = 0.25
			Pickable.resource_type.shovel:
				shovel_sprite.modulate.a = 0.25

func localize_and_show_message(message_key:String):
	message_panel.show_message(tr(message_key))
	
func show_message(message_key:String):
	message_panel.show_message(message_key)

func message_closed(): 
	on_message_closed.emit()

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
	
func flash_item(item:Pickable.resource_type):
	match item:
			Pickable.resource_type.food:
				flash_sprite(food_sprite)
			Pickable.resource_type.wood:
				flash_sprite(wood_sprite)
			Pickable.resource_type.shovel:
				flash_sprite(shovel_sprite)

func flash_sprite(texture:TextureRect):
	var tween = get_tree().create_tween()
	for n in 15:
		randomize()
		tween.tween_property(texture, "position", Vector2(randi_range(-10, 10), randi_range(-10, 10)), 0.05).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(texture, "position", Vector2.ZERO, 0.1)



