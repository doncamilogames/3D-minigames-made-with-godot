extends KinematicBody
var up = 0
var down = 0
var left = 0
var right = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(up == 1):
		global_transform.origin.x -= 0.01
	if(down == 1):
		global_transform.origin.x += 0.01
	if(left == 1):
		global_transform.origin.z += 0.01
	if(right == 1):
		global_transform.origin.z -= 0.01
		
		
		
func _on_up_pressed():
	up = 1
	get_node("basefornpc/Anim").play("walk")
func _on_up_released():
	up = 0
	get_node("basefornpc/Anim").play("idle")
func _on_down_pressed():
	down = 1
	get_node("basefornpc/Anim").play("walk")
func _on_down_released():
	down = 0
	get_node("basefornpc/Anim").play("idle")
func _on_left_pressed():
	left = 1
	get_node("basefornpc/Anim").play("walk")
func _on_left_released():
	left = 0
	get_node("basefornpc/Anim").play("idle")
func _on_right_pressed():
	right = 1
	get_node("basefornpc/Anim").play("walk")
func _on_right_released():
	right = 0
	get_node("basefornpc/Anim").play("idle")
