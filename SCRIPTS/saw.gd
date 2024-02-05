extends Enemy

@onready var path_follow_2d = %PathFollow2D
@onready var saw_sprite = %SawSprite

@export var movement_speed:float = 1
@export var rotation_speed:float = 800

func _process(delta):
	path_follow_2d.progress_ratio += delta * movement_speed
	saw_sprite.rotation_degrees += delta * rotation_speed
