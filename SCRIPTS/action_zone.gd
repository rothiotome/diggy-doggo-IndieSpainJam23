extends Area2D

class_name action_zone

@export var type:zone_type

@onready var action_sprite:Sprite2D = $Node2D/Action

var tween:Tween

enum zone_type {
	sleep,
	dig
}

func do_action():
	match type:
		zone_type.sleep:
			var anim_fire = $AnimatedFire as AnimatedSprite2D
			anim_fire.animation = "on"
			$Bed/Animatedbed.show()
		zone_type.dig:
			$hole.update_visuals()

func show_action():
	match type:
		zone_type.sleep:
			if !Globals.has_item(Pickable.resource_type.food) || !Globals.has_item(Pickable.resource_type.wood): return
		zone_type.dig:
			if !Globals.has_item(Pickable.resource_type.shovel) : return
	action_sprite.visible = true
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(action_sprite, "position", Vector2.DOWN*2, 0.2)
	tween.tween_property(action_sprite, "position", Vector2.UP*2, 0.2)
	
func hide_action():
	if tween != null:
		tween.kill()
	action_sprite.visible = false

func _on_tree_exiting():
	if tween != null:
		tween.kill()
