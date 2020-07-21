extends Node2D


onready var monkeys = $monkeys
onready var hammer = $hammer
onready var hammer_tween = $hammer/tween
onready var Monkey = load("res://scenes/monkey.tscn")


var possible_spawns = [
	make_point(Vector2(100, 250), 90, Vector2.RIGHT),
	make_point(Vector2(250, 100), -90, Vector2.LEFT),
]

var state = "move"
var monkeys_list = []

var i = 0


func _ready():
	
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _physics_process(delta):
	
	match state:
		"move":
			if Input.is_action_just_pressed("attack"):
				hammer.get_node("monkey_detector/collider").disabled = false
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
		hammer.get_node("monkey_detector/collider").disabled = true



func _on_monkey_detector_area_entered(area):
	area.get_parent().queue_free()


func make_point(spawn_point, rot_deg, dir):
	return {"spawn_point": spawn_point, "rot_deg": rot_deg, "dir": dir}


func _on_spawn_timer_timeout():
	var info = possible_spawns[randi()% possible_spawns.size()]
	monkeys_list.push_back(Monkey.instance())
	monkeys_list[i].dir= info["dir"]
	monkeys_list[i].rot_deg = info["rot_deg"]
	monkeys_list[i].global_position = info["spawn_point"]
	monkeys.add_child(monkeys_list[i])
	i += 1
