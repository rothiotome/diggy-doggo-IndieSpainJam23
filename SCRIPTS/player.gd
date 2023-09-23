extends CharacterBody2D

class_name player

@export var velocity_multiplier:float = 600.0
@export var invulnerability_time:float = 1.0

@onready var effects_anim = $Effects
@onready var invulnerability_timer:Timer = $InvulnerabilityTimer
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite

@onready var ui:player_ui = $UI

var current_zone:action_zone = null

signal on_pick_object 
signal on_hurt

var is_invulnerable:bool = false

func _ready():
	Engine.time_scale = 1

func _physics_process(_delta):
	get_input()
	move_and_slide()
	animate()

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * velocity_multiplier
	
	if Input.is_action_just_pressed("ui_accept"): try_to_action()

func animate():
	walk()
	#roll()
	
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

func frame_freeze(duration):
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
	
func try_to_action():
	if current_zone == null: return
	match current_zone.type:
		action_zone.zone_type.sleep:
			if Globals.has_item(Pickable.resource_type.wood) && Globals.has_item(Pickable.resource_type.food):
				get_parent().sleep()
		action_zone.zone_type.dig:
			if Globals.has_item(Pickable.resource_type.shovel):
				get_parent().dig()
				
func _on_timer_timeout():
	is_invulnerable = false
	
func _on_pickable_box_area_entered(area):
	if !Globals.has_item(area.type):
		area.pick()
		on_pick_object.emit(area.type, true)
	else:
		on_pick_object.emit(area.type, false)

func _on_hurt_box_area_entered(area):
	if is_invulnerable: return
	on_hurt.emit(area.parent.damage_amount)
	frame_freeze(0.2)
	start_invulnerability()

func _on_interaction_box_area_entered(area:action_zone):
	match area.type:
		action_zone.zone_type.sleep:
			ui.show_sleep_stuff()
		action_zone.zone_type.dig:
			ui.show_dig_stuff()
	area.show_action()
	current_zone = area
	
func _on_interaction_box_area_exited(area):
	match area.type:
		action_zone.zone_type.sleep:
			area.hide_action()
			ui.hide_sleep_stuff()
		action_zone.zone_type.dig:
			area.hide_action()
			ui.hide_dig_stuff()
	current_zone = null

