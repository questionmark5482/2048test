extends Sprite2D
var num = 0
var num_label
var row_ind
var col_ind

# Called when the node enters the scene tree for the first time.
func _ready():
	num_label = get_node("num_label")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_to(destination):
	pass

func refresh(n):
	num = n
	if n != 0:
		num_label.text = str(n)
		visible = true
	else:
		num_label.text = " "
		visible = false
	

func debug_show():
	print("Block (" + str(row_ind) + ", " + str(col_ind) + "), value is " + str(num))
