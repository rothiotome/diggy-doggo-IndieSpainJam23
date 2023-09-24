extends Camera2D

@export var tween_duration:float = 0.1

var tween

func move(target_position:Vector2):
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, tween_duration).set_trans(Tween.TRANS_SINE)
	
