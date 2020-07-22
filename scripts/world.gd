extends Node2D


onready var monkeys = $monkeys
onready var hammer = $hammer
onready var hammer_tween = $hammer/tween
onready var Monkey = load("res://scenes/monkey.tscn")


var possible_spawns = [
	make_point(Vector2(505, 1315), 60, Vector2.RIGHT),
	make_point(Vector2(485, 1315), -60, Vector2.LEFT),
	make_point(Vector2(525, 1120), 130, (Vector2.RIGHT + Vector2.DOWN).normalized()),
	make_point(Vector2(420, 1125), -140, (Vector2.LEFT + Vector2.DOWN).normalized()),
	make_point(Vector2(335, 950), -80, Vector2.LEFT),
	make_point(Vector2(220, 690), -15, Vector2.UP),
	make_point(Vector2(230, 760), -160, Vector2.DOWN),
	make_point(Vector2(312, 600), -45, (Vector2.LEFT + Vector2.UP).normalized()),
	make_point(Vector2(415, 775), -16, Vector2.UP),
	make_point(Vector2(490, 600), -40, (Vector2.LEFT + Vector2.UP).normalized()),
	make_point(Vector2(575, 640), 45, (Vector2.RIGHT + Vector2.UP).normalized()),
	make_point(Vector2(680, 755), -12, Vector2.UP),
	make_point(Vector2(640, 910), 135, (Vector2.RIGHT + Vector2.DOWN).normalized()),
	make_point(Vector2(515, 1115), 100, Vector2.RIGHT),
	make_point(Vector2(515, 1515), 64, Vector2.RIGHT),
	make_point(Vector2(480, 1515), -64, Vector2.LEFT)
]

var state = "move"
var monkeys_list = []

var i = 0
var score = -1
var highscore = 0
var score_text
var highscore_text


func _ready():
	
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	$ui/score_label.text = "Score: "
	score_text = $ui/score_label.text
	$ui/highscore_label.text = "High Score: "
	highscore_text = $ui/highscore_label.text
	
	if load_data('highscore'):
		highscore = (load_data('highscore'))
	increase_score()

func _physics_process(delta):
	
	match state:
		"move":
			if Input.is_action_just_pressed("attack"):
				hammer.get_node("monkey_detector/collider").disabled = false
				state = "wait"
				rotate_hammer()
			hammer.global_position = get_global_mouse_position()
	
	score = max(score, 0)


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
	increase_score()
	print(score)


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


func decrease_score():
	score = max(score - 1, 0)
	$ui/score_label.text = score_text + str(score)


func increase_score():
	score += 1
	if highscore < score:
		highscore = score
		save_data(highscore, 'highscore')
	$ui/highscore_label.text = highscore_text + str(highscore)
	$ui/score_label.text = score_text + str(score)


#Saving Highscore
func save_data(data, file, path = "res"):

	# Create and open file.
	var SAVE_PATH = path+'://'+file+'.json'
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

	# Convert data to a useable string-format.
	save_file.store_line(to_json(data))

	# Close file.
	save_file.close()


func load_data(file, empty = null, path = "res"):
	# Create file
	var SAVE_PATH = path+"://"+file+".json"
	var save_file = File.new()
	
	if save_file.file_exists(SAVE_PATH):
		# Open your file
		save_file.open(SAVE_PATH, File.READ)
		
		# Save data from file.
		var data = parse_json(save_file.get_as_text())
		
		# Close file 
		save_file.close()
		
		# Return data
		return data
	else:
		return empty
