extends Area2D

class_name Pickable

@export var type:resource_type

@onready var sprite_2d = $Sprite2D

enum resource_type {food, wood, shovel}
var is_picked:bool = false

func pick():
	set_state(false)
	
func reset():
	set_state(true)
	
func set_state(new_state):
	is_picked = !new_state
	sprite_2d.visible = new_state
	visible = new_state
	



