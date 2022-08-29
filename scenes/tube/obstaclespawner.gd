extends Spatial
onready var rng = RandomNumberGenerator.new()
var block5
var block7
var childs = []
onready var timer = get_parent().get_parent().get_node("Timer")
var oldrng = -1
var speed = 0
var uvpos = 0

var speedtemp = .2
func _ready():
	rng.randomize()
	set_physics_process(true)
	_on_Timer_timeout()

	
	
	
	
func _newblock():
	if(get_parent().get_parent()._level == 1):
		speed = get_parent().get_parent().obstaclespeed
		var newrng =  rng.randi_range(0,9)
		if(newrng != oldrng and abs(oldrng - newrng ) < 3): #1 = crash !!!
			block5 = preload("res://scenes/tube/5.tscn").instance()
			childs.append(block5)
			block5.rotation_degrees.y = 36 * newrng
			self.add_child(block5)
			oldrng = newrng
		else:
			_newblock()
	if(get_parent().get_parent()._level == 2 ):
		speed = get_parent().get_parent().obstaclespeed
		var newrng =  rng.randi_range(0,9)
		if(newrng != oldrng and abs(oldrng - newrng ) < 3): #1 = crash !!!
			var newrng2 =  rng.randi_range(1,2)
			if(newrng2 == 1):
				block5 = preload("res://scenes/tube/5.tscn").instance()
				childs.append(block5)
				block5.rotation_degrees.y = 36 * newrng
				self.add_child(block5)
				oldrng = newrng
			if(newrng2 == 2):
				block7 = preload("res://scenes/tube/7.tscn").instance()
				childs.append(block7)
				block7.rotation_degrees.y = 36 * newrng
				self.add_child(block7)
				oldrng = newrng
		else:
			_newblock()
	if(get_parent().get_parent()._level == 3):
		speed = get_parent().get_parent().obstaclespeed
		var newrng =  rng.randi_range(0,9)
		if(newrng != oldrng and abs(oldrng - newrng ) < 3): #1 = crash !!!
			block7 = preload("res://scenes/tube/7.tscn").instance()
			childs.append(block7)
			block7.rotation_degrees.y = 36 * newrng
			self.add_child(block7)
			oldrng = newrng
		else:
			_newblock()
	speedtemp = speed * (get_parent().get_parent().level / 10)

	if(speedtemp > 2):
		speedtemp = 2


func _on_Timer_timeout():
	_newblock()
	timer.start()


func _physics_process(delta):
	uvpos -= speedtemp / 10
	if(uvpos <= -1000):
		uvpos = 0
	get_parent().get_surface_material(0).set_uv1_offset(Vector3(0,uvpos,0))
	
#	if(get_parent().get_parent().started == 1):
	for i in childs:

			i.move_and_collide(Vector3(0,-1,0) *speedtemp ,true,true, false)
	#		i.global_transform.origin.z -=   speed * (get_parent().get_parent().level / 6)
			if(i.global_transform.origin.y < 15):
				get_parent().get_parent().currentscore +=1
				get_parent().get_parent()._updatehud()
				i.queue_free()
				childs.erase(i)
				get_parent().get_parent().get_node("sounds").set_stream(preload("res://asset/sounds/tac1.wav"))
				get_parent().get_parent().get_node("sounds").play()
