extends ColorRect

var config_file = ConfigFile.new()
var err = config_file.load("user://settings.cfg")

@onready var spanish = $VBoxContainer/Languages/Spanish
@onready var english = $VBoxContainer/Languages/English
@onready var music_slider = $VBoxContainer/MusicSlider
@onready var sfx_slider = $VBoxContainer/SFXSlider

func _ready():
	if (err == OK):
		var music_volume = config_file.get_value("SETTINGS", "MUSIC_VOLUME")
		music_slider.value = music_volume
		_on_music_slider_value_changed(music_volume)
		var sfx_volume = config_file.get_value("SETTINGS", "SFX_VOLUME")
		sfx_slider.value = sfx_volume
		_on_sfx_slider_value_changed(sfx_volume)
		var language = config_file.get_value("SETTINGS", "LANGUAGE")
		if(language == "en"): 
			_on_english_pressed()
		else: 
			_on_spanish_pressed()
	else:
		music_slider.value = 5
		sfx_slider.value = 5
		if TranslationServer.get_locale().begins_with("es"):
			_on_spanish_pressed()
		else:
			_on_english_pressed()
		_on_music_slider_value_changed(5)
		_on_sfx_slider_value_changed(5)

func _on_music_slider_value_changed(value):
	var music_index = AudioServer.get_bus_index("Music")
	if value==0:
		AudioServer.set_bus_volume_db(music_index, -144)
	else:
		AudioServer.set_bus_volume_db(music_index, (20 * (log(value) / log(10))) - 20)
	config_file.set_value("SETTINGS", "MUSIC_VOLUME", value)
	config_file.save("user://settings.cfg")

func _on_sfx_slider_value_changed(value):
	var sfx_index = AudioServer.get_bus_index("sfx")
	if value==0:
		AudioServer.set_bus_volume_db(sfx_index, -144)
	else:
		AudioServer.set_bus_volume_db(sfx_index, (20 * (log(value) / log(10))) - 20)
	config_file.set_value("SETTINGS", "SFX_VOLUME", value)
	config_file.save("user://settings.cfg")

func _on_english_pressed():
	english.disabled = true
	spanish.disabled = false
	TranslationServer.set_locale("en")
	config_file.set_value("SETTINGS", "LANGUAGE", "en")
	config_file.save("user://settings.cfg")

func _on_spanish_pressed():
	english.disabled = false
	spanish.disabled = true
	TranslationServer.set_locale("es")
	config_file.set_value("SETTINGS", "LANGUAGE", "es")
	config_file.save("user://settings.cfg")

func _on_back_button_pressed():
	hide()

func _on_visibility_changed():
	if visible: 
		Engine.time_scale = 0
		spanish.grab_focus()
	else: 
		Engine.time_scale = 1
		$"../SplashScreen/VBoxContainer/play".grab_focus()
