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
	
func player_hurt(damage:int):
	if(daylight_timer.time_left - damage <= 0): game_over()
	else: daylight_timer.start(daylight_timer.time_left - damage)

func player_picked_object(type:Pickable.resource_type):
	canvas_layer.pick_item(type)
	
func game_over():
	print("GameOver")
	get_tree().reload_current_scene()

func _on_daylight_timer_timeout():
	Globals.current_daylight_duration = Globals.daylight_duration
	start_day()

