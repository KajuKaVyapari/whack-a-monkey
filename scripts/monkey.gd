extends Sprite


onready var tween = $monkey_tween
onready var hitbox_collider = $monkey_hitbox/collider

var rot_deg
var dir

onready var or_pos = position
onready var fn_pos = or_pos + 50 * dir


func _ready():
	
	rotation_degrees = rot_deg
	hitbox_collider.disabled = false
	tween.interpolate_property(self, "position", or_pos, fn_pos, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()


func _on_monkey_tween_completed(object, key):
	
	if object.position == fn_pos:
		tween.interpolate_property(self, "position", fn_pos, or_pos, 1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		get_parent().get_parent().decrease_score()
		queue_free()
