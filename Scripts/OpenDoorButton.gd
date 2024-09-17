extends Area2D

class_name OpenDoorButton

@onready var released_sprite:Sprite2D = $released
@onready var pushed_sprite:Sprite2D = $pushed

signal on_button_pushed

var isPushed:bool = false

func _on_body_entered(body):
	if(body.name == "Player"):
		push()

func push():
	if(!isPushed):
		released_sprite.visible=false
		pushed_sprite.visible=true
		
		on_button_pushed.emit()
	
