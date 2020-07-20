extends Node2D

onready var monkeys = $monkeys
onready var hammer = $hammer
onready var hammer_tween = $hammer/tween


var possible_spawns = [
	Vector2(300, 120),
	Vector2(100, 250)
]


func _ready():
	
	randomize()
	hammer_tween.interpolate_property(hammer, "global_position",  hammer.global_position, possible_spawns[randi() % 2], 1, hammer_tween.TRANS_SINE, hammer_tween.EASE_IN_OUT)
	hammer_tween.start()
