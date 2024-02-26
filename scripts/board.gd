extends Node2D
var blocks = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]

var alive = true

var move_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	debug_print_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func initialize():
	spawn_number()
	pass
	
	
func spawn_number():
	var temp = []
	for ii in range(4):
		for jj in range(4):
			var num = blocks[ii][jj]
			if num == 0:
				temp.append([ii, jj])
	var l = len(temp)
	if l == 0:
		game_over()
		return
	var r1 = randi_range(0, l-1)
	var r2 = randi_range(0, l-1)
	if r1 == r2:
		var ii = temp[r1][0]
		var jj = temp[r1][1]
		blocks[ii][jj] = 4
	else:
		var i1 = temp[r1][0]
		var j1 = temp[r1][1]
		var i2 = temp[r2][0]
		var j2 = temp[r2][1]
		blocks[i1][j1] = 2
		blocks[i2][j2] = 2
	pass


func debug_print_board():
	print("Printing from board.gd: ")
	print(blocks[0])
	print(blocks[1])
	print(blocks[2])
	print(blocks[3])


func slide_left():
	for row_index in range(4):
		var row = blocks[row_index]
		var non_zeros = []
		for num in row:
			if num != 0:
				non_zeros.append(num)
		# convert non_zeros into new_row. 
		var new_row = []
		while non_zeros:
			var a = non_zeros.pop_front()
			if non_zeros == []:
				new_row.append(a)
				break
			if non_zeros[0] == a:
				non_zeros.pop_front()
				new_row.append(a*2)
			else:
				new_row.append(a)
		for ii in range(4 - len(new_row)):
			new_row.append(0)
		blocks[row_index] = new_row
		
func slide_right():
	for row_index in range(4):
		var row = blocks[row_index]
		var non_zeros = []
		for num in row:
			if num != 0:
				non_zeros.append(num)
		# convert non_zeros into new_row. 
		var new_row = []
		while non_zeros:
			var a = non_zeros.pop_back()
			if non_zeros == []:
				new_row.push_front(a)
				break
			if non_zeros[-1] == a:
				non_zeros.pop_back()
				new_row.push_front(a*2)
			else:
				new_row.push_front(a)
		for ii in range(4 - len(new_row)):
			new_row.push_front(0)
		blocks[row_index] = new_row

func slide_up():
	var new_blocks = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
	for row_index in range(4):
		# pick a "row" according to direction
		var row = []
		for jj in range(4):
			row.append(blocks[jj][row_index])
		
		var non_zeros = []
		for num in row:
			if num != 0:
				non_zeros.append(num)
		# convert non_zeros into new_row. 
		var new_row = []
		while non_zeros:
			var a = non_zeros.pop_front()
			if non_zeros == []:
				new_row.push_back(a)
				break
			if non_zeros[0] == a:
				non_zeros.pop_front()
				new_row.push_back(a*2)
			else:
				new_row.push_back(a)
		for ii in range(4 - len(new_row)):
			new_row.push_back(0)
		
		for jj in range(4):
			new_blocks[jj][row_index] = new_row[jj]
	blocks = new_blocks
	
func slide_down():
	var new_blocks = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
	for row_index in range(4):
		# pick a "row" according to direction
		var row = []
		for jj in range(4):
			row.append(blocks[jj][row_index])
		
		var non_zeros = []
		for num in row:
			if num != 0:
				non_zeros.append(num)
		# convert non_zeros into new_row. 
		var new_row = []
		while non_zeros:
			var a = non_zeros.pop_back()
			if non_zeros == []:
				new_row.push_front(a)
				break
			if non_zeros[-1] == a:
				non_zeros.pop_back()
				new_row.push_front(a*2)
			else:
				new_row.push_front(a)
		for ii in range(4 - len(new_row)):
			new_row.push_front(0)
		
		for jj in range(4):
			new_blocks[jj][row_index] = new_row[jj]
	blocks = new_blocks
 
func _input(event):
	if not alive:
		return
	
	if event.is_action_released("ui_left"):
		slide_left()
	elif event.is_action_pressed("ui_right"):
		slide_right()
	elif event.is_action_pressed("ui_up"):
		slide_up()
	elif event.is_action_pressed("ui_down"):
		slide_down()
	else:
		return
	move_count += 1
	print("Move No. " + str(move_count))
	spawn_number()
	debug_print_board()


func game_over():
	print("Game Over!")
