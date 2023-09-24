extends AudioStreamPlayer

class_name AudioManager

var clips:Array[String] = ["res://MUSIC/DavidKBD - InterstellarPack - 01 - Interstellar.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 02 - Plasma Storm.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 03 - Temple of Madness.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 04 - Horsehead Nebula.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 05 - Forgotten Station.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 06 - Hope on the Horizon.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 07 - Electric Firework.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 08 - Synth Kobra.ogg", "res://MUSIC/DavidKBD - InterstellarPack - 09 - Spiral of Plasma.ogg"]
var tween:Tween

var filter:AudioEffectLowPassFilter = null

func _ready():
	filter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	stream = load(clips[randi_range(0, clips.size()-1)])
	play()

func fade_in():
	if tween:
		tween.kill()
	if get_tree() == null: return
	var tween = get_tree().create_tween()
	tween.tween_property(filter, "cutoff_hz", 20000, 0.4)
	tween.tween_property(self, "volume_db", 0, 0.4)

func fade_out():
	if tween:
		tween.kill()
	var tween = get_tree().create_tween()
	tween.tween_property(filter, "cutoff_hz", 2000, 0.4)
	tween.tween_property(self, "volume_db", -10, 0.4)
