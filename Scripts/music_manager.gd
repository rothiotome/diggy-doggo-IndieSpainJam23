extends AudioStreamPlayer

class_name MusicManager

var clips:Array[String] = ["res://Music/DavidKBD - InterstellarPack - 01 - Interstellar.ogg", "res://Music/DavidKBD - InterstellarPack - 02 - Plasma Storm.ogg", "res://Music/DavidKBD - InterstellarPack - 03 - Temple of Madness.ogg", "res://Music/DavidKBD - InterstellarPack - 04 - Horsehead Nebula.ogg", "res://Music/DavidKBD - InterstellarPack - 05 - Forgotten Station.ogg", "res://Music/DavidKBD - InterstellarPack - 06 - Hope on the Horizon.ogg", "res://Music/DavidKBD - InterstellarPack - 07 - Electric Firework.ogg", "res://Music/DavidKBD - InterstellarPack - 08 - Synth Kobra.ogg", "res://Music/DavidKBD - InterstellarPack - 09 - Spiral of Plasma.ogg"]
var tween:Tween

var filter: AudioEffectLowPassFilter = null

func _ready():
	filter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	stream = load(clips[randi_range(0, clips.size()-1)])
	play()

func fade_in():
	if tween:
		tween.kill()
	if not is_node_ready(): return
	var tween = get_tree().create_tween()
	tween.tween_property(filter, "cutoff_hz", 20000, 0.4)

func fade_out():
	if tween:
		tween.kill()
	if not is_node_ready(): return
	var tween = get_tree().create_tween()
	tween.tween_property(filter, "cutoff_hz", 2000, 0.4)
