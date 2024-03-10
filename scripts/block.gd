extends Sprite2D
var num = 0
var num_label
var row_ind
var col_ind

var moving = false
var move_tot_time = 0.1
#var move_start_time
var move_cur_time = 0
var destination: Vector2
var old_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	num_label = get_node("num_label")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		move_cur_time += delta
		position = old_position + move_lambda(move_cur_time) * (destination - old_position)
		if move_cur_time >= move_tot_time:
			position = destination
			moving = false


func move_to(input_destination: Vector2):
#	position = input_destination
	destination = input_destination
	old_position = position
	moving = true
#	move_start_time = Time.get_unix_time_from_system()
	pass

func refresh(n):
	num = n
	if n != 0:
		num_label.text = str(n)
		visible = true
	else:
		num_label.text = " "
		visible = false
	
func move_lambda(t):
	return t/move_tot_time

func debug_show():
	print("Block (" + str(row_ind) + ", " + str(col_ind) + "), value is " + str(num))

func merge_to(input_destination: Vector2):
	pass
