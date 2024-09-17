extends Control

@onready var text:Label = $message_border/message_canvas/text
@onready var message_border = $message_border
@onready var action_image = $message_border/message_canvas/Control/action_image


signal on_message_closed

var message_is_visible = false

func _process(_delta):
	if !message_is_visible: return
	if Input.is_action_just_pressed("ui_accept"): hide_message()

func hide_message():
	action_image.visible = false
	message_border.hide()
	text.text = ""
	message_is_visible = false
	on_message_closed.emit()

func show_message(message:String):
	message_border.show()
	text.text = message
	get_tree().create_timer(1).timeout.connect(can_close_message)
	
func show_final_message(message:String):
	$congratulations_message.show()
	$congratulations_message/message_canvas/text.text = message
	$congratulations_message/message_canvas/fireworks_blue.emitting = true
	$congratulations_message/message_canvas/fireworks_red.emitting = true
	$congratulations_message/message_canvas/fireworks_green.emitting = true
	
func can_close_message():
	message_is_visible = true
	action_image.visible = true
