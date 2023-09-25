extends Node

var left_step:bool = true

@onready var steps_l:AudioStreamPlayer = $"steps-L"
@onready var steps_r:AudioStreamPlayer = $"steps-R"
@onready var door:AudioStreamPlayer = $door
@onready var pick:AudioStreamPlayer = $pick
@onready var shovel:AudioStreamPlayer = $shovel
@onready var hurt:AudioStreamPlayer = $hurt
@onready var wrong:AudioStreamPlayer = $wrong
@onready var interferences:AudioStreamPlayer = $interferences

func play_pick():
	play_random_pitch(pick)

func play_wrong():
	play_random_pitch(wrong)

func play_shovel():
	for n in 4:
		play_random_pitch(shovel)
		await get_tree().create_timer(0.2).timeout # Godot 4 yield syntax
		n += 1
		
func play_hurt():
	play_random_pitch(interferences)
	play_random_pitch(hurt)

func play_step():
	randomize()
	if left_step:
		steps_l.pitch_scale = randf_range(0.7, 0.9)
		steps_l.play()
	else:
		steps_r.pitch_scale = randf_range(0.9, 1.2)
		steps_r.play()

func play_door():
	door.play()

func play_random_pitch(stream_player):
	randomize()
	stream_player.pitch_scale = randf_range(0.8, 1.2)
	stream_player.play()
