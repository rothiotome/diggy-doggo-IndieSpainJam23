extends Node2D

var connected_rooms = {
	Vector2.RIGHT: null,
	Vector2.LEFT: null,
	Vector2.DOWN: null,
	Vector2.UP: null
}

@onready var up_door:door = $up_door
@onready var down_door:door = $down_door
@onready var left_door:door = $left_door
@onready var right_door:door = $right_door

@onready var open_door_button:OpenDoorButton = $OpenDoorButton

var number_of_connections:int = 0

var reward:Pickable

func _ready():
	open_door_button.on_button_pushed.connect(open_room_doors)
	reward = get_reward()
	if Globals.consumed_room.has(self.scene_file_path): disable_reward()
	if reward != null : reward.on_picked.connect(reward_picked)
	
func setup():
	for r in connected_rooms:
		if connected_rooms[r] == null:
			match r:
				Vector2.UP: up_door.set_door_state(door.door_state.DISABLED)
				Vector2.DOWN: down_door.set_door_state(door.door_state.DISABLED)
				Vector2.RIGHT: right_door.set_door_state(door.door_state.DISABLED)
				Vector2.LEFT: left_door.set_door_state(door.door_state.DISABLED)

func open_room_doors():
	open_if_enabled(up_door)
	open_if_enabled(down_door)
	open_if_enabled(right_door)
	open_if_enabled(left_door)

	for r in connected_rooms:
		if connected_rooms[r] != null:
			connected_rooms[r].open_opposite_door(r)

func _on_area_2d_body_entered(body):
	if(body.name == "Player"):
		get_node("/root/World/Camera2D").move(self.global_position)

func open_if_enabled(target_door):
	if(target_door.current_door_state != door.door_state.DISABLED): 
		target_door.call_deferred("set_door_state", door.door_state.OPENED)

func open_opposite_door(dir):
	match dir:
		Vector2.UP: down_door.call_deferred("set_door_state", door.door_state.OPENED)
		Vector2.DOWN: up_door.call_deferred("set_door_state", door.door_state.OPENED)
		Vector2.RIGHT: left_door.call_deferred("set_door_state", door.door_state.OPENED)
		Vector2.LEFT: right_door.call_deferred("set_door_state", door.door_state.OPENED)

func reward_picked():
	Globals.consumed_room.append(self.scene_file_path)

func get_reward() -> Pickable:
	var child = find_child("pickable_*")
	return child
	
func disable_reward():
	reward.pick()
