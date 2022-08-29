extends RigidBody

var _shooter
var strength = 1.0
func _ready():
	var _material = load("res://scenes/kinematic/tile/fire1.tres")
	_material = _material.duplicate()
	get_node("MeshInstance").set_surface_material(0,_material)

func _on_fireball_body_entered(body):
	if(body.has_method("_bounce")):
		pass
	else:
	#	if(body != _shooter):
			if(body.has_method("_shooted")):
				body._shooted(strength)
			get_node("AnimationPlayer").play("explode")
			get_node("AudioStreamPlayer").play()
			set_linear_velocity(Vector3.ZERO)

func _explode():
	queue_free()
