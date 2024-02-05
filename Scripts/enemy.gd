class_name Enemy

extends Node2D

@export var damage_amount:int = 20

func _ready():
	%Area2D.parent = self
