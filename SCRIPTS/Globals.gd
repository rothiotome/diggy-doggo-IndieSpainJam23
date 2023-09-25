extends Node

const daylight_duration:float = 120
var current_daylight_duration:float = 120
var hole_size:int = 0

var consumed_room:Array = []
var inventory:Array[Pickable.resource_type] = []
var current_day:int = 0

var sleep_message_seen:bool = false
var dig_message_seen:bool = false

func has_item(type) -> bool:
	return inventory.has(type)

func remove_item(type):
	inventory.erase(type)

func reset():
	hole_size = 0
	current_day = 0
	current_daylight_duration = daylight_duration
	consumed_room = []
	inventory.clear()
	sleep_message_seen = false
	dig_message_seen = false
