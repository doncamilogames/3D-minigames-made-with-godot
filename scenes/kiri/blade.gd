extends RigidBody


export var _type = ""
func _ready():
	set_linear_velocity(Vector3(2,0,0))
#	bounce = 1.0
	if(_type == "invert"):
			set_linear_velocity(Vector3(-2,0,0))
	if(_type == "2"):
			set_linear_velocity(Vector3(0,0,2))
func _on_blade_body_entered(body):
	set_linear_velocity(linear_velocity * -1)
	
	
	
