extends Node2D

@export var damage_amount:int = 20

func _ready():
	$SawSprite/Area2D.parent = self
