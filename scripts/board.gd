extends Node2D
var block_vectors = []
var game_manager
var block_scene = preload("res://Scenes/Block.tscn")
var active_blocks = []

var instruction_list = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var block_distance = 120
	var block_shift = Vector2(-350, 200)
	var x_coordinates = [0*block_distance, 1*block_distance, 2*block_distance, 3*block_distance] 
	var y_coordinates = [0*block_distance, 1*block_distance, 2*block_distance, 3*block_distance]
	for ii in range(4):
		var block_vectors_row = []
		for jj in range(4):
			var cur_vec = Vector2(x_coordinates[jj], -y_coordinates[3-ii]) + block_shift
			block_vectors_row.append(cur_vec)
		block_vectors.append(block_vectors_row)
		
	# nodes
	game_manager = get_parent()
	# we should also draw lines between blocks.
	
	# signals
	game_manager.send_instruction.connect(_on_instructed)
	game_manager.move_blocks.connect(_on_move_blocks)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_instructed(instructions):
	if len(instructions) == 0:
		return
	instruction_list.append_array(instructions)


func _on_move_blocks():
	for instruction in instruction_list:
		execute_instruction(instruction)
	instruction_list = []
	pass

func execute_instruction(input_instruction):
#	print("Executing instruction: " + str(input_instruction))
	if not input_instruction:
		return
	var ii = input_instruction[1][0]
	var jj = input_instruction[1][1]
	if input_instruction[0] == "spawn":
		spawn_block(ii, jj, input_instruction[2])
		
	else:
		var iii = input_instruction[2][0]
		var jjj = input_instruction[2][1]
		if input_instruction[0] == "move":
			move_block(ii, jj, iii, jjj)
		elif input_instruction[0] == "merge":
			merge_block(ii, jj, iii, jjj)


func spawn_block(ii, jj, num):
	var cur_vec = block_vectors[ii][jj]
	var cur_block = block_scene.instantiate()
	add_child(cur_block)
	active_blocks.append(cur_block)
	cur_block.position = cur_vec
	cur_block.row_ind = ii
	cur_block.col_ind = jj
	cur_block.set_up()

func move_block(ii, jj, iii, jjj):
	for block in active_blocks:
		if block.row_ind == ii and block.col_ind == jj:
			block.move_to(block_vectors[iii][jjj])
			block.row_ind = iii
			block.col_ind = jjj
			return

func merge_block(ii, jj, iii, jjj):
#	# refresh the value
#	for b_ind in range(len(active_blocks)):
#		var block = active_blocks[b_ind]
#		if block.row_ind == iii and block.col_ind == jjj:
#			block.refresh(game_manager.blocks[iii][jjj])
#			break
	# move and destroy		
	for b_ind in range(len(active_blocks)):
		var block = active_blocks[b_ind]
#		print("checking block: (" + str(block.row_ind) + ", " + str(block.col_ind) + ")")
		if block.row_ind == ii and block.col_ind == jj:
#			print("found block to purge")
			block.merge_to(block_vectors[iii][jjj])
			# then destroy block!
			# remove from active
			active_blocks.remove_at(b_ind)
			return

func debug_print_active():
	print("active blocks are:")
	for b in active_blocks:
		b.debug_show()
