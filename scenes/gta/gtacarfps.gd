extends StaticBody
var nearchest = 0
var color 
onready var rng = RandomNumberGenerator.new()
onready var brokenbodymat  = load("res://asset/mesh/gta/carmetalbroke.tres")
onready var metalparts = [[get_node("Mesh/all"),1],[get_node("Mesh/door1/door1"),0],[get_node("Mesh/door2/door2"),0],[get_node("Mesh/door3/door3"),1],[get_node("Mesh/door4/door4"),1],[get_node("Mesh/chest/chest"),1]]
var checked = 0

func _ready():
	rng.randomize()
	rotation_degrees.y = rng.randi_range(0,360)
	brokenbodymat = brokenbodymat.duplicate()
	color = rng.randi_range(1,5)
	if(color == 0):#white
		color = "ffffff"
	elif(color == 1):#red
		color = "ff0000"
	elif(color == 2):#green
		color = "5cff00"
	elif(color == 3):#blue
		color = "0081ff"
	elif(color == 4):#yellow
		color = "ffc500"
	elif(color == 5):#black
		color = "3a1f42"
	for i in metalparts:
			i[0].set_surface_material(i[1],brokenbodymat)
			i[0].get_surface_material(i[1]).set_albedo(color)


func _on_Areachest_body_entered(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "startcar" and body.mode != "stopcar"):
				get_parent().closeobject = self
				get_parent()._closeobject("carchest")
				nearchest = 1

func _on_Areachest_body_exited(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "startcar" and body.mode != "stopcar"):
				get_parent().closeobject = null
				get_parent()._closeobject("null")
				nearchest = 0
func _car():
	pass


func _on_Areatoofar_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().carnear -= 1
		queue_free()
