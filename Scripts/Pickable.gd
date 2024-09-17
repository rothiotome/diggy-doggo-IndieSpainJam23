extends Area2D

class_name Pickable

@export var type:resource_type

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

signal on_picked;

enum resource_type {food, wood, shovel}
var is_picked:bool = false

func _ready():
	set_state(false)

func pick():
	Globals.inventory.append(type)
	is_picked = true
	on_picked.emit()
	call_deferred("set_state", false)

func show_pickable():
	if is_picked: return
	call_deferred("set_state", true)

func set_state(new_state):
	collision_shape_2d.disabled = !new_state
	sprite_2d.visible = new_state
	




