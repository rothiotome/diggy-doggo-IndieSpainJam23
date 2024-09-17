extends Node2D

var dungeon: Dictionary = {}

@onready var map_node:Node2D = $MapNode
@onready var daylight_timer:Timer = $DaylightTimer
@onready var player: Player = $Player
@onready var canvas_layer:canvas_controller = $CanvasLayer
@onready var music:MusicManager = $MusicManager

@onready var camera = %Camera2D

@onready var fader = $fader

var game_is_over:bool = false
var just_slept:bool = false

const room_size:int = 160

func _ready():
	dungeon = dungeon_generation.generate(randi_range(-100, 100))
	load_map()
	start_day()
	player.on_hurt.connect(player_hurt)
	player.on_pick_object.connect(player_picked_object)
	player.on_action_area_entered.connect(action_area_entered)
	canvas_layer.on_message_closed.connect(on_message_closed)


func load_map():
	for i in dungeon.keys():
		map_node.add_child(dungeon[i])
		dungeon[i].position = i * room_size
		dungeon[i].setup()
		dungeon[i].on_player_enter.connect(move_camera_to_pos)
		var c_rooms = dungeon.get(i).connected_rooms

func start_day():
	daylight_timer.stop()
	daylight_timer.wait_time = Globals.daylight_duration
	daylight_timer.start()
	show_message("HOME_MESSAGE" if Globals.current_day == 0 else "SHINY_DAY")
	Globals.current_day += 1
	
func player_hurt(damage:int):
	if daylight_timer.time_left - damage <= 0: game_over()
	else: 
		daylight_timer.start(daylight_timer.time_left - damage)
		canvas_layer.flash_time_left()
		AudioManager.play_hurt()
		Globals.number_of_hits += 1

func player_picked_object(type:Pickable.resource_type, succeed):
	if succeed: 
		canvas_layer.pick_item(type)
		AudioManager.play_pick()
	else: 
		canvas_layer.flash_item(type)
		AudioManager.play_wrong()
	
func enter_home():
	music.fade_out()
	daylight_timer.paused = true
	
func exit_home():
	music.fade_in()
	daylight_timer.paused = false
	
func sleep(area:action_zone):
	if !Globals.sleep_message_seen: return
	if Globals.message_is_open: return
	show_message("SLEEPING_ACTION")
	Globals.remove_item(Pickable.resource_type.food)
	Globals.remove_item(Pickable.resource_type.wood)
	canvas_layer.remove_item(Pickable.resource_type.food)
	canvas_layer.remove_item(Pickable.resource_type.wood)
	area.do_action()
	fader.play("fade_out")
	just_slept = true
	

func dig(area:action_zone):
	if !Globals.dig_message_seen: return
	if Globals.message_is_open: return
	
	AudioManager.play_shovel()
	Globals.remove_item(Pickable.resource_type.shovel)
	canvas_layer.remove_item(Pickable.resource_type.shovel)
	player.hide_ui()
	Globals.hole_size += 1
	area.do_action()
	if(Globals.hole_size == 5):
		canvas_layer.show_final_message()
		player.can_move = false
	else:
		show_message("DIGGING_ACTION")
	
func action_area_entered(area:action_zone.zone_type):
	if !Globals.sleep_message_seen and area == action_zone.zone_type.sleep:
		show_message("BED_MESSAGE")
		Globals.sleep_message_seen = true
	elif !Globals.dig_message_seen and area == action_zone.zone_type.dig:
		show_message("DIG_MESSAGE")
		Globals.dig_message_seen = true

func game_over():
	daylight_timer.stop()
	game_is_over = true
	show_message("DIE_MESSAGE")
	player.kill()
	
func reload_scene():
	get_tree().reload_current_scene()

func show_message(message:String):
	player.pause_movement()
	Globals.message_is_open = true
	canvas_layer.show_message(message)
	
func move_camera_to_pos(pos):
	player.can_move = false
	await %Camera2D.move(pos)
	player.can_move = true

func on_message_closed():
	player.restore_movement()
	Globals.message_is_open = false
	if Globals.hole_size == 5 or game_is_over:
		Globals.reset()
		fader.play("fade_out")
		await fader.animation_finished
		reload_scene()
	if just_slept:
		just_slept = false
		reload_scene()


func _on_daylight_timer_timeout():
	game_over()
