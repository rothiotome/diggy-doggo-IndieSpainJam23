extends Node2D

class_name door

@onready var opened_sprite:Sprite2D = $"door-opened"
@onready var closed_sprite:Sprite2D = $"door-closed"
@onready var static_body:CollisionShape2D = $StaticBody2D/CollisionShape2D

enum door_state {OPENED, CLOSED, DISABLED}

@export var current_door_state:door_state = door_state.CLOSED

func _ready():
	set_door_state(current_door_state)

func set_door_state(new_state:door_state):
	current_door_state = new_state
	match current_door_state:
		door_state.CLOSED:
			opened_sprite.visible = false
			closed_sprite.visible = true
			static_body.disabled = false
		door_state.OPENED:
			opened_sprite.visible = true
			closed_sprite.visible = false
			static_body.disabled = true
		door_state.DISABLED:
			opened_sprite.visible = false
			closed_sprite.visible = false
			static_body.disabled = false
