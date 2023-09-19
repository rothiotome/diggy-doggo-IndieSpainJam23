extends CharacterBody2D

class_name player
@export var velocity_multiplier:float = 200.0

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * velocity_multiplier

func _physics_process(delta):
	get_input()
	move_and_slide()

