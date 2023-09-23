extends Node2D

@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var sprite_2d = $Path2D/PathFollow2D/SawSprite

@export var damage_amount:int = 10

@export var movement_speed:float = 1
@export var rotation_speed:float = 800

func _ready():
	$Path2D/PathFollow2D/SawSprite/Area2D.parent = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow_2d.progress_ratio += delta*movement_speed
	sprite_2d.rotation_degrees += delta*rotation_speed
