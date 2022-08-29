extends Area
var getter
var _owner
func _ready():
	set_process(false)

func _on_coin_body_entered(body):
	if(body.has_method("_on_J2_pressed") and getter == null):
		body._getmoney(1)
		if(_owner != null):
			_owner._getobj()
		getter = body
		set_process(true)
		get_node("Sprite3D").scale = Vector3(1,1,1)
		get_node("Timer").start()
		body._playsound("getcoin")
		
		
func _process(delta):
	if(getter != null):
		global_transform.origin = getter.global_transform.origin
		global_transform.origin.y += 2.8

func _on_Timer_timeout():
		queue_free()
