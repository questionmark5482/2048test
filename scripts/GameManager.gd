extends Node2D

var blocks = [[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
var alive = true
var move_count = 0
var board

# signals:
signal send_instruction(instructions) # Form: ["move", [i,j], [ii,jj]], ["merge", [i,j], [ii,jj]], or ["spawn", [i,j], num]
signal move_blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_number()
	debug_print_board()
	board = get_node("Board")
	move_blocks.emit()
	
	
func spawn_number():
	var spawn_signal = []
	var vacants = []
	for ii in range(4):
		for jj in range(4):
			if blocks[ii][jj] == 0:
				vacants.append([ii, jj])
	var l = len(vacants)
	var r1 = randi_range(0, l-1)
	var r2 = randi_range(0, l-1)
	if r1 == r2:
		var ii = vacants[r1][0]
		var jj = vacants[r1][1]
		blocks[ii][jj] = 4
		spawn_signal.append(["spawn", [ii, jj], 4])
	else:
		var i1 = vacants[r1][0]
		var j1 = vacants[r1][1]
		var i2 = vacants[r2][0]
		var j2 = vacants[r2][1]
		blocks[i1][j1] = 2
		blocks[i2][j2] = 2
		spawn_signal.append(["spawn", [i1, j1], 2])
		spawn_signal.append(["spawn", [i2, j2], 2])
	send_instruction.emit(spawn_signal)

func try_slide(dir):
	# Key function after each input
	move_count += 1
	print(" ")
	print("Move No. " + str(move_count))
	
	# rotate
	var blocks_rotated = rotate_blocks(dir, blocks)
	# check if possible to slide left
	var is_move_legal = slide_check(blocks_rotated)
	if is_move_legal == false:
		print("Illegal move!")
		blocks = rotate_blocks(dir, blocks_rotated)
	else:
		# slide_left()
		var new_blocks_rotated = slide_left(blocks_rotated, dir)
		# rotate back
		blocks = rotate_blocks(dir, new_blocks_rotated)
		spawn_number()
		game_over_check()
		move_blocks.emit()
	debug_print_board()
	return

func slide_check(input_block) -> bool:
	for row in input_block:
		# if any row is slidable, return true
		# a row is slidable iff (0 before number) or (identical neighbor not 0)
		# 0 before number check
		var ind = 3
		for jj in range(4):
			if row[jj] == 0:
				ind = jj
				break            # find the left most zero
		for kk in range(ind + 1, 4):
			if row[kk] != 0:
#				print("found vacant in row: " + str(row) + "slidable")
				return true
		# identical non-zero neighbor check
		var prev = row[0]
		for jj in range(1, 4):
			var cur = row[jj]
			if cur == prev and cur != 0:
#				print("found identical neighbor in row: " + str(row) + "slidable")
				return true
			prev = cur
#	print("not slidable!")
	return false

func rotate_blocks(dir, input_blocks = blocks):
	# rule: left -> no change. right -> reflection. up -> transpose. down -> the other transpose
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
				row.append(input_blocks[3-jj][3-ii])
			ans.append(row)
	return ans

func slide_left(input_blocks, dir):
	var move_merge_signals = []
	var new_blocks = []
	for row_index in range(4):
		var row = input_blocks[row_index]
		# from row generate new row.
		var merged = true
		var new_row = [0, 0, 0, 0]
		var new_ind = 0
		for jj in range(4):
			if row[jj] == 0:
				continue
			if not merged:
				if new_row[new_ind-1] == row[jj]:
					# merge
					new_row[new_ind-1] *= 2
					merged = true
					var temp_signal = ["merge", [row_index, jj], [row_index, new_ind-1]]
					move_merge_signals.append(translate_signal(temp_signal, dir))
				else:
					#slide
					new_row[new_ind] = row[jj]
					var temp_signal = ["move", [row_index, jj], [row_index, new_ind]]
					move_merge_signals.append(translate_signal(temp_signal, dir))
					new_ind += 1
			else:
				# slide
				new_row[new_ind] = row[jj]
				var temp_signal = ["move", [row_index, jj], [row_index, new_ind]]
				move_merge_signals.append(translate_signal(temp_signal, dir))
				new_ind += 1
				merged = false
		new_blocks.append(new_row)
#	print(move_merge_signals)
	send_instruction.emit(move_merge_signals)
	return new_blocks

func translate_signal(input_signal, dir):
	if input_signal[0] == "move" or input_signal[0] == "merge":
		var ii = input_signal[1][0]
		var jj = input_signal[1][1]
		var iii = input_signal[2][0]
		var jjj = input_signal[2][1]
		if dir == "left":
			return input_signal
		elif dir == "right":
			return [input_signal[0], [ii, 3-jj], [iii, 3-jjj]]
		elif dir == "up":
			return [input_signal[0], [jj, ii], [jjj, iii]]
		elif dir == "down":
			return [input_signal[0], [3-jj, 3-ii], [3-jjj, 3-iii]]

func game_over_check():
	print("checking gameover")
	# game over iff no zero and no identical neighbor
	for ii in range(4):
		for jj in range(4):
			if blocks[ii][jj] == 0:
				print("detected 0, still alive")
				return
			# check identical neighbor
			for dd in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
				var iii = ii + dd[0]
				var jjj = jj + dd[1]
				if iii < 0 or iii > 3 or jjj < 0 or jjj > 3:
					continue
				if blocks[iii][jjj] == blocks[ii][jj] and blocks[ii][jj] != 0:
					print("detected identical neighbor, still alive")
					return
				
	print("Game Over!")
	alive = false
	return	
	

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
		blocks[0][0] = 2048
		send_instruction.emit([["spawn", [0, 0], 2048]])
		move_blocks.emit()
		pass
	else:
		return

func debug_print_board():
	print("Printing from board.gd: ")
	print(blocks[0])
	print(blocks[1])
	print(blocks[2])
	print(blocks[3])
