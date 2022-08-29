extends Area
var getter
var _owner
export var pohswitch = ""
func _ready():
	if(pohswitch != ""):
		if(Global.mot.pohswitch.find(pohswitch) != -1):
			queue_free()
	else:
			queue_free()
	set_process(false)
	
func _process(delta):
	if(getter != null):
		global_transform.origin = getter.global_transform.origin
		global_transform.origin.y += 3.0

func _on_Timer_timeout():
		queue_free()


func _on_poh_body_entered(body):
	if(body.has_method("_on_J2_pressed") and getter == null):
		body._getpoh()
		Global.mot.pohswitch.append(pohswitch)
		if(_owner != null):
			_owner._getobj()
		getter = body
		set_process(true)
		get_node("Sprite3D").scale = Vector3(3,3,3)
		get_node("Timer").start()

