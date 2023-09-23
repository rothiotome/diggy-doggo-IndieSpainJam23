extends Node2D

class_name player_ui

@export var color_red:Color = Color("ff666f")
@export var color_green:Color = Color("2dbd90")

@onready var sleep_thoughts = $sleep_thoughts
@onready var dig_thoughts = $dig_thoughts

@onready var bubble_food:Sprite2D = $"sleep_thoughts/bubble-food"
@onready var bubble_wood:Sprite2D = $"sleep_thoughts/bubble-wood"
@onready var bubble_shovel:Sprite2D = $"dig_thoughts/bubble-shovel"

func show_sleep_stuff():
	bubble_food.show()
	bubble_wood.show()
	
	bubble_food.self_modulate = color_green if Globals.has_item(Pickable.resource_type.food) else color_red
	bubble_wood.self_modulate = color_green if Globals.has_item(Pickable.resource_type.wood) else color_red
	
func show_dig_stuff():
	bubble_shovel.show()
	bubble_shovel.self_modulate = color_green if Globals.has_item(Pickable.resource_type.shovel) else color_red
	pass

func hide_sleep_stuff():
	bubble_food.hide()
	bubble_wood.hide()
	pass
	
func hide_dig_stuff():
	bubble_shovel.hide()
	pass
