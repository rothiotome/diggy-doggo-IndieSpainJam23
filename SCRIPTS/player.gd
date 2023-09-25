extends CharacterBody2D

class_name player

@export var velocity_multiplier:float = 600.0

@onready var effects_anim = $Effects
@onready var invulnerability_timer:Timer = $InvulnerabilityTimer
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite

@onready var ui:player_ui = $UI

var current_zone:action_zone = null

signal on_pick_object 
signal on_hurt
signal on_action_area_entered

var can_move:bool = true
var is_invulnerable:bool = false
var is_hurting:bool = false

var is_dead:bool = false

func _ready():
	Engine.time_scale = 1

func _physics_process(_delta):
	if is_dead: return
	if Globals.is_splash_screen_open: return
	get_input()
	if !can_move: velocity = Vector2.ZERO
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
		if is_hurting:
			match anim.current_animation:
				"walk_R": anim.play("hurt_R")
				"walk_U": anim.play("hurt_U")
				"walk_D": anim.play("hurt_D")
				"idle_R": anim.play("hurt_R")
				"idle_U": anim.play("hurt_U")
				"idle_D": anim.play("hurt_D")
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
	can_move = false
	is_hurting = true
	is_invulnerable = true
	invulnerability_timer.start(0.2)
	effects_anim.play("blink")

func frame_freeze(duration):
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
	
func restore_movement():
	can_move = true
	
func pause_movement():
	can_move = false

func hide_ui():
	current_zone.hide_action()
	ui.hide_dig_stuff()
	ui.hide_sleep_stuff()

func try_to_action():
	if current_zone == null: return
	if get_parent().message_is_open:return
	match current_zone.type:
		action_zone.zone_type.sleep:
			if Globals.has_item(Pickable.resource_type.wood) && Globals.has_item(Pickable.resource_type.food):
				get_parent().sleep(current_zone)
				hide()
		action_zone.zone_type.dig:
			if Globals.has_item(Pickable.resource_type.shovel):
				get_parent().dig(current_zone)

func kill():
	is_dead = true
	is_invulnerable = true
	anim.play("death_D")

func play_step():
	AudioManager.play_step()

func _on_timer_timeout():
	if is_hurting:
		is_hurting = false
		can_move = true
		invulnerability_timer.start(1.3)
	else:
		is_invulnerable = false
	
func _on_pickable_box_area_entered(area):
	if !Globals.has_item(area.type):
		area.pick()
		on_pick_object.emit(area.type, true)
	else:
		on_pick_object.emit(area.type, false)

func _on_hurt_box_area_entered(area):
	if is_invulnerable: return
	if is_dead: return
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
	on_action_area_entered.emit(area.type)
	current_zone = area
	
func _on_interaction_box_area_exited(area):
	match area.type:
		action_zone.zone_type.sleep:
			ui.hide_sleep_stuff()
		action_zone.zone_type.dig:
			ui.hide_dig_stuff()
	area.hide_action()
	current_zone = null
