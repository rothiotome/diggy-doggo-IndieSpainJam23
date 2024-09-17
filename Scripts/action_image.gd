extends TextureRect

var tween

func _ready():
	tween = create_tween()
	tween.tween_property(self, "position:y", -38, 0.2)
	tween.tween_property(self, "position:y", -32, 0.2)
	tween.set_loops()

func _exit_tree():
	tween.stop()
	tween.kill()
