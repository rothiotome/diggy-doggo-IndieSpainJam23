extends Node2D

var dungeon = {}

@onready var map_node = $MapNode

const room_size:int = 160

func _ready():
	dungeon = dungeon_generation.generate(randi_range(-100, 100))
	load_map()

func load_map():
	for i in dungeon.keys():
		map_node.add_child(dungeon[i])
		dungeon[i].position = i * room_size
		dungeon[i].setup_door()
		var c_rooms = dungeon.get(i).connected_rooms
