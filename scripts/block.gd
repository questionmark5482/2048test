extends Sprite2D
var num = 0
var num_label
var row_ind
var col_ind



#var move_start_time
var move_cur_time = 0
var destination: Vector2
var old_position: Vector2

var spawned_time
var normal_scale = Vector2(5, 5)
var stress_begin_time
var stress_factor = 0.15


# status variables
var spawn_scaling = true
var moving = false
var to_be_destroyed = false
var stress_scaling = false

# Durations
var move_tot_time = 0.1
var spawn_duration = 0.1
var spawn_wait_time = 0.075
var stress_duration = 0.15

# Nodes
var board


# Called when the node enters the scene tree for the first time.
func _ready():
	num_label = get_node("num_label")
	spawned_time = Time.get_unix_time_from_system()
	
	
	# get nodes
	board = get_parent()

func set_up():
	num = board.game_manager.blocks[row_ind][col_ind]
	num_label.text = str(num)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawn_scaling:
		handle_spawn_scaling()
	if stress_scaling:
		handle_stress_scaling(stress_begin_time)
	if moving:
		handle_move(delta)


		
func move_to(input_destination: Vector2):
	destination = input_destination
	old_position = position
	moving = true
#	move_start_time = Time.get_unix_time_from_system()

	
func merge_to(input_destination: Vector2):
	destination = input_destination
	old_position = position
	moving = true
	to_be_destroyed = true

	
func refresh():
	var n = board.game_manager.blocks[row_ind][col_ind]
	if num != n:
		num = n
		stress_begin_time = Time.get_unix_time_from_system()
		stress_scale()
	num_label.text = str(n)

func stress_scale():
	stress_scaling = true


func move_lambda(t):
	return t/move_tot_time

func debug_show():
	print("Block (" + str(row_ind) + ", " + str(col_ind) + "), value is " + str(num))



func handle_spawn_scaling():
	var cur_time = Time.get_unix_time_from_system() - spawned_time
	scale = normal_scale * max((cur_time-spawn_wait_time)/spawn_duration, 0)
	if cur_time-spawn_wait_time >= spawn_duration:
		scale = normal_scale
		spawn_scaling = false
		
func handle_stress_scaling(begin_time):
	var cur_time = Time.get_unix_time_from_system() - begin_time
	var tt = cur_time/stress_duration
	var cur_factor = min(2*tt, 2 - 2*tt) * stress_factor
	scale = normal_scale * (1 + cur_factor)
#	print(cur_factor)
	if cur_time >= stress_duration:
		scale = normal_scale
		stress_scaling = false
		
func handle_move(delta):
	move_cur_time += delta
	position = old_position + move_lambda(move_cur_time) * (destination - old_position)
	if move_cur_time >= move_tot_time:
		move_cur_time = 0
		if to_be_destroyed:
			queue_free()
		position = destination
		moving = false
		refresh()
