extends CharacterBody2D

class_name player

@export var velocity_multiplier:float = 600.0
@export var invulnerability_time:float = 1.0

@onready var effects_anim = $Effects
@onready var invulnerability_timer:Timer = $InvulnerabilityTimer
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite

signal on_pick_object 
signal on_hurt

var is_invulnerable:bool = false

func _ready():
	Engine.time_scale = 1

func _physics_process(delta):
	get_input()
	move_and_slide()
	animate()

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * velocity_multiplier

func animate():
	#walk()
	roll()
	
func walk():
	if velocity != Vector2.ZERO: 
		sprite.flip_h = velocity.x < 0
		if abs(velocity.x) > abs(velocity.y): anim.play("walk_R")
		else:
			if velocity.y < 0: anim.play("walk_U")
			else: anim.play("walk_D")
	else:
		match anim.current_animation:
			"walk_R": anim.play("idle_R")
			"walk_U": anim.play("idle_U")
			"walk_D": anim.play("idle_D")

func roll():
	if velocity != Vector2.ZERO: 
		sprite.flip_h = velocity.x < 0
		if abs(velocity.x) > abs(velocity.y): anim.play("roll_R")
		else:
			if velocity.y < 0: anim.play("roll_U")
			else: anim.play("roll_D")
	else:
		match anim.current_animation:
			"roll_R": anim.play("idle_R")
			"roll_U": anim.play("idle_U")
			"roll_D": anim.play("idle_D")
	
	
func start_invulnerability():
	invulnerability_timer.start(1)
	effects_anim.play("blink")
	is_invulnerable = true

func _on_timer_timeout():
	is_invulnerable = false

func frameFreeze(duration):
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1

func _on_pickable_box_area_entered(area):
	area.pick()
	on_pick_object.emit(area.type)

func _on_hurt_box_area_entered(area):
	if is_invulnerable: return
	on_hurt.emit(area.parent.damage_amount)
	frameFreeze(0.2)
	start_invulnerability()
