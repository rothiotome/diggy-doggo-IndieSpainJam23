extends Node2D

@export var camera:Node2D

func _on_area_2d_body_entered(body):
	camera.move(self.global_position)
