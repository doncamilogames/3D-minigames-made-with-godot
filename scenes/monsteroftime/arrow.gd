extends RigidBody
var strength = 10.0
var used = 0
var _owner
var getter
func _ready():
	set_process(false)
	if(_owner != null): #means it's a collectable
		used = 1

func _on_arrow_body_entered(body):
	if(_owner == null):
		if( used == 0 ):
			if(body.has_method("_bounce")):
				pass
			else:
				if(body.has_method("_shooted")):
						body._shooted(strength)
				set_linear_velocity(Vector3.ZERO)
				if(body.name == "ground"):
					self.set_gravity_scale(0.0)
					set_sleeping(true)
					mode =RigidBody.MODE_STATIC 
				else:
					self.set_gravity_scale(1.0)
				used = 1


func _on_Area_body_entered(body):
	if(body.has_method("_on_J2_pressed") and getter == null and used == 1):
		body._getarrow(1)
		if(_owner != null):
			_owner._getobj()
		getter = body
		set_process(true)
		get_node("Timer").start()
		body._playsound("object3")
		get_node("MeshInstance").scale = Vector3(0.3,0.3,0.3)
		get_node("CollisionShape").scale = Vector3(0.3,0.3,0.3)
func _process(delta):
	if(getter != null):
		global_transform.origin = getter.global_transform.origin
		global_transform.origin.y += 3.1


func _on_Timer_timeout():
		queue_free()

