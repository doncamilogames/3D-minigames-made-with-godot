extends RigidBody

var _shooter
var strength = 1.0
func _ready():
#	var _material = load("res://scenes/macronbros/tile/fire1.tres")
#	_material = _material.duplicate()
#	get_node("MeshInstance").set_surface_material(0,_material)
	pass

func _explode():

	queue_free()


func _on_rocket_body_entered(body):
	set_linear_velocity(Vector3.ZERO)
	get_node("Animexplode").play("explode")
	get_node("AudioStreamPlayer3D").set_stream(load("res://asset/sounds/explo1.wav"))
	get_node("AudioStreamPlayer3D").play()
	if(body.has_method("_target")):
		body._target()


func _on_Timer_timeout():

	queue_free()
