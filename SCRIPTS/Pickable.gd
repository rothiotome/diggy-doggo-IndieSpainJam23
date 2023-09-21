extends Area2D

class_name Pickable

@export var type:resource_type

@onready var sprite_2d = $Sprite2D

signal on_picked;

enum resource_type {food, wood, shovel}
var is_picked:bool = false

func pick():
	is_picked = true
	on_picked.emit()
	set_state(false)

func show_pickable():
	set_state(true)

func set_state(new_state):
	sprite_2d.visible = new_state
	visible = new_state




