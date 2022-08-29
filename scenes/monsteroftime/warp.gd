extends Area

export var _scene = ""
export var _spawn = ""
func _ready():
	pass 

func _on_warp_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		Global.mot.spawn = _spawn
		Global.mot.changescene = _scene
		get_parent().get_node("Animtransition").play("fadeout")
		get_parent().get_parent().get_node("Kinemonster").mode = "warping"
		get_parent().get_parent().get_node("Kinemonster").fixedpos = get_parent().get_parent().get_node("Kinemonster/Spring/SpringArm/Camera").global_transform.origin

		
		
		
		
		

