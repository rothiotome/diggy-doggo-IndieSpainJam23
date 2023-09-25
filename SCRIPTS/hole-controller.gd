extends Sprite2D

var current_visuals:int = 0
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D

const radius:Array[int] = [1, 6, 8, 10, 16]

func _ready():
	update_visuals()

func update_visuals():
	if(Globals.hole_size == current_visuals): return
	
	collision_shape_2d.shape.radius = radius[current_visuals]
	current_visuals = Globals.hole_size
	frame = current_visuals
