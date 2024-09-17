extends Control

@onready var text : Label = $PanelContainer/MarginContainer/text
@onready var message_border = $PanelContainer
@onready var action_image = $PanelContainer/MarginContainer/Control/action_image


signal on_message_closed
signal on_game_finished

var message_is_visible = false
var game_finished = false


func _process(_delta):
	if !message_is_visible: return
	if Input.is_action_just_pressed("ui_accept"): hide_message()
	if game_finished: on_game_finished.emit()


func hide_message():
	action_image.visible = false
	message_border.hide()
	text.text = ""
	message_is_visible = false
	on_message_closed.emit()
	$fireworks_blue.emitting = false
	$fireworks_red.emitting = false
	$fireworks_green.emitting = false

func show_message(message:String):
	text.text = message
	message_border.show()
	get_tree().create_timer(1).timeout.connect(can_close_message)
	
func show_final_message(stats:Array):
	message_border.show()
	text.set_text(tr("VICTORY_MESSAGE") % stats)
	$fireworks_blue.emitting = true
	$fireworks_red.emitting = true
	$fireworks_green.emitting = true
	get_tree().create_timer(5).timeout.connect(can_close_message)
	
func can_close_message():
	message_is_visible = true
	action_image.visible = true
