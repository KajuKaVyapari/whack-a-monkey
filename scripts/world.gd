extends Node2D

onready var monkeys = $monkeys
onready var hammer = $hammer
onready var hammer_tween = $hammer/tween


var possible_spawns = [
	Vector2(300, 120),
	Vector2(100, 250)
]

var state = "move"


func _ready():
	
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _physics_process(delta):
	
	match state:
		"move":
			if Input.is_action_just_pressed("attack"):
				state = "wait"
				rotate_hammer()
			hammer.global_position = get_global_mouse_position()
		


func rotate_hammer():
	hammer_tween.interpolate_property(hammer, "rotation_degrees", 0, -45, .5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	hammer_tween.start()


func _on_tween_completed(object, key):
	if object.rotation_degrees == -45:
		hammer_tween.interpolate_property(hammer, "rotation_degrees", -45, 0, .5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		hammer_tween.start()
	else:
		get_viewport().warp_mouse(hammer.global_position)
		yield(get_tree(), "idle_frame")
		state = "move"
