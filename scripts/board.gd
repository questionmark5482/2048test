extends Node2D

var blocks = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
var alive = true
var move_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	debug_print_board()


func initialize():
	spawn_number()
	
	
func spawn_number():
	var temp = []
	for ii in range(4):
		for jj in range(4):
			var num = blocks[ii][jj]
			if num == 0:
				temp.append([ii, jj])
	var l = len(temp)
	if l == 0:
		game_over_check()
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

func try_slide(dir):
	# check if possible
	
	# rotate
	var blocks_rotated = rotate_blocks(dir)
	# slide_left()
	var new_blocks_rotated = slide_left(blocks)
	# rotate back
	
	blocks = new_blocks_rotated
	pass

func rotate_blocks(dir, input_blocks = blocks):
	# rule: left -> no change. right -> reflection. up -> transpose. down -> transpose and inversion
	var ans = []
	if dir == "left":
		for ii in range(4):
			var row = []
			for jj in range(4):
				row.append(input_blocks[ii][jj])
			ans.append(row)
	elif dir == "right":
		for ii in range(4):
			var row = []
			for jj in range(4):
				row.append(input_blocks[ii][3 - jj])
			ans.append(row)
	elif dir == "up":
		for ii in range(4):
			var row = []
			for jj in range(4):
				row.append(input_blocks[jj][ii])
			ans.append(row)
	elif dir == "down":
		for ii in range(4):
			var row = []
			for jj in range(4):
				row.append(input_blocks[jj][3 - ii])
			ans.append(row)
	print("rotated block is: ")
	print(ans)
#	print(ans[0])
#	print(ans[1])
#	print(ans[2])
#	print(ans[3])
			

func slide_left(input_blocks):
	var new_blocks = []
	for row_index in range(4):
		var row = input_blocks[row_index]
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
		new_blocks.append(new_row)
	return new_blocks
	
func _input(event):
	if not alive:
		return
	
	if event.is_action_released("ui_left"):
		try_slide("left")
	elif event.is_action_pressed("ui_right"):
		try_slide("right")
	elif event.is_action_pressed("ui_up"):
		try_slide("up")
	elif event.is_action_pressed("ui_down"):
		try_slide("down")
	elif event.is_action_pressed("test_input"):
		var test_blocks = [[1,2,3,4], [0,5,0,0], [0,0,6,0], [0,0,0,7]]
		print(rotate_blocks("left", test_blocks))
		print(rotate_blocks("right", test_blocks))
		print(rotate_blocks("up", test_blocks))
		print(rotate_blocks("dosn", test_blocks))
	else:
		return
	move_count += 1
	print("Move No. " + str(move_count))
	spawn_number()
	debug_print_board()


func game_over_check():
	print("Game Over!")
	# alive = false
