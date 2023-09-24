extends Node2D

var dungeon = {}

@onready var map_node:Node2D = $MapNode
@onready var daylight_timer:Timer = $DaylightTimer
@onready var player:player = $Player
@onready var canvas_layer:canvas_controller = $CanvasLayer
@onready var music:AudioManager = $AudioStreamPlayer

@onready var fader = $fader

const room_size:int = 160

func _ready():
	TranslationServer.set_locale(Globals.current_language)
	dungeon = dungeon_generation.generate(randi_range(-100, 100))
	load_map()
	start_day()
	player.on_hurt.connect(player_hurt)
	player.on_pick_object.connect(player_picked_object)
	player.on_action_area_entered.connect(action_area_entered)
	canvas_layer.connect("on_message_closed", on_message_closed)

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
	show_message("HOME_MESSAGE" if Globals.current_day == 0 else "SHINY_DAY")
	Globals.current_day += 1
	
func player_hurt(damage:int):
	if(daylight_timer.time_left - damage <= 0): game_over()
	else: daylight_timer.start(daylight_timer.time_left - damage)

func player_picked_object(type:Pickable.resource_type, succeed):
	if succeed: canvas_layer.pick_item(type)
	else: canvas_layer.flash_item(type)
	
func enter_home():
	music.fade_out()
	daylight_timer.paused = true
	
func exit_home():
	music.fade_in()
	daylight_timer.paused = false
	
func sleep(area:action_zone):
	show_message("SLEEPING_ACTION")
	Globals.remove_item(Pickable.resource_type.food)
	Globals.remove_item(Pickable.resource_type.wood)
	canvas_layer.remove_item(Pickable.resource_type.food)
	canvas_layer.remove_item(Pickable.resource_type.wood)
	area.do_action()
	fader.play("fade_out")

func dig(area:action_zone):
	show_message("DIGGING_ACTION")
	Globals.remove_item(Pickable.resource_type.shovel)
	canvas_layer.remove_item(Pickable.resource_type.shovel)
	player.hide_ui()
	Globals.hole_size += 1
	area.do_action()

func action_area_entered(area:action_zone.zone_type):
	if !Globals.sleep_message_seen and area == action_zone.zone_type.sleep:
		show_message("BED_MESSAGE")
		Globals.sleep_message_seen = true
	elif !Globals.dig_message_seen and area == action_zone.zone_type.dig:
		show_message("DIG_MESSAGE")
		Globals.dig_message_seen = true

func game_over():
	show_message("DIE_MESSAGE")
	Globals.reset()
	fader.play("fade_out")
	
func reload_scene():
	get_tree().reload_current_scene()

func show_message(message:String):
	player.pause_movement()
	canvas_layer.localize_and_show_message(message)

func fade_out_ended():
	reload_scene()

func on_message_closed():
	player.restore_movement()
	
func _on_daylight_timer_timeout():
	game_over()
