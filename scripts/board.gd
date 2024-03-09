extends Node2D
var block_vectors = []
var game_manager
var block_scene = preload("res://Scenes/Block.tscn")
var active_blocks = [[],[],[],[]]


# Called when the node enters the scene tree for the first time.
func _ready():
	var block_distance = 120
	var block_shift = Vector2(-350, 200)
	var x_coordinates = [0*block_distance, 1*block_distance, 2*block_distance, 3*block_distance] 
	var y_coordinates = [0*block_distance, 1*block_distance, 2*block_distance, 3*block_distance]
	for ii in range(4):
		for jj in range(4):
			var cur_vec = Vector2(x_coordinates[jj], -y_coordinates[3-ii]) + block_shift
			block_vectors.append(cur_vec)
			var cur_block = block_scene.instantiate()
			add_child(cur_block)
			active_blocks[ii].append(cur_block)
			cur_block.position = cur_vec
			cur_block.refresh(0)
	game_manager = get_parent()
	# we should also draw lines between blocks.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func test_show_numbers():
	var temp_b = game_manager.blocks
	for ii in range(4):
		for jj in range(4):
			active_blocks[ii][jj].refresh(temp_b[ii][jj])
	pass
