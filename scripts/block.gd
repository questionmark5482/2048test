extends Sprite2D
var num = 0
var num_label
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
	else:
		num_label.text = " "
	
