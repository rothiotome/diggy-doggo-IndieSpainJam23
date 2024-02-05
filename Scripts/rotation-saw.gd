extends Sprite2D

@export var rotation_steps: int = 12  # Cantidad de pasos en una rotación completa
@export var rotation_duration: float = 1.0  # Duración total de la rotación en segundos

var current_step: int = 0
var step_angle: float
var time_elapsed: float = 0.0

func _ready():
	step_angle = 360.0 / rotation_steps

func _process(delta):
	time_elapsed += delta

	if time_elapsed >= rotation_duration / rotation_steps:
		time_elapsed = 0.0
		current_step = (current_step + 1) % rotation_steps

	var target_rotation = current_step * step_angle
	rotation_degrees = target_rotation
