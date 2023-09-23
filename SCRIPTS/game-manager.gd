extends Node2D

var dungeon = {}

@onready var map_node:Node2D = $MapNode
@onready var daylight_timer:Timer = $DaylightTimer
@onready var player:player = $Player
@onready var canvas_layer = $CanvasLayer


const room_size:int = 160

func _ready():
	dungeon = dungeon_generation.generate(randi_range(-100, 100))
	load_map()
	start_day()
	player.on_hurt.connect(player_hurt)
	player.on_pick_object.connect(player_picked_object)

func load_map():
	for i in dungeon.keys():
		map_node.add_child(dungeon[i])
		dungeon[i].position = i * room_size
		dungeon[i].setup()
		var c_rooms = dungeon.get(i).connected_rooms

func start_day():
	daylight_timer.stop()
	daylight_timer.wait_time = Globals.daylight_duration
	daylight_timer.start()
	show_message("SHINNY_DAY")
	
func player_hurt(damage:int):
	if(daylight_timer.time_left - damage <= 0): game_over()
	else: daylight_timer.start(daylight_timer.time_left - damage)

func player_picked_object(type:Pickable.resource_type):
	canvas_layer.pick_item(type)
	
func enter_home():
	daylight_timer.paused = true
	
func exit_home():
	daylight_timer.paused = false
	
func sleep():
	Globals.remove_item(Pickable.resource_type.food)
	Globals.remove_item(Pickable.resource_type.wood)
	canvas_layer.remove_item(Pickable.resource_type.food)
	canvas_layer.remove_item(Pickable.resource_type.wood)
	reload_scene()

func dig():
	show_message("DIGGING_ACTION")
	Globals.remove_item(Pickable.resource_type.shovel)
	canvas_layer.remove_item(Pickable.resource_type.shovel)
	Globals.hole_size += 1

func _on_daylight_timer_timeout():
	game_over()
	
func game_over():
	show_message("DIE_MESSAGE")
	Globals.reset()
	reload_scene()
	
func reload_scene():
	get_tree().reload_current_scene()

func show_message(message:String):
	canvas_layer.localize_and_show_message(message)
