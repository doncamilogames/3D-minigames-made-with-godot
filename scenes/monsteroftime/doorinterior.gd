extends StaticBody


var playercurrentroom = ""
var _used = 0
export var frontroom = ""
export var backroom = ""
export var switch = ""


func _ready():
	
	set_process(false)
	

func _action():
	if(switch == "" or( switch != ""  and Global.mot.switch.find(switch) != -1)  ):
		if(_used == 0):
			set_process(true)
			_used = 1
			get_node("AnimationPlayer").play("open")
			get_parent().get_parent().get_node("Kinemonster").mode = "changingroom"
			if(playercurrentroom == "front"):#display back room
					get_parent().get_parent().get_node("Kinemonster").global_transform.origin = get_node("front").global_transform.origin
					get_tree().current_scene.find_node(backroom).visible = true
			if(playercurrentroom == "back"):#display back room
					get_parent().get_parent().get_node("Kinemonster").global_transform.origin = get_node("back").global_transform.origin
					get_tree().current_scene.find_node(frontroom).visible = true
			get_parent().get_parent().get_node("Kinemonster").look_at(self.global_transform.origin,Vector3.UP)
			get_parent().get_parent().get_node("Kinemonster").rotation_degrees.x = 0
			get_parent().get_parent().get_node("Kinemonster").rotation_degrees.z = 0
			get_parent().get_parent().get_node("Kinemonster").rotation_degrees.y += 180
		
	else:
		get_tree().current_scene.find_node("Kinemonster")._playsound("error")

		
func _process(delta):
	if(_used == 1):
		if(playercurrentroom == "front"):
				get_parent().get_parent().get_node("Kinemonster").global_transform.origin = get_node("front").global_transform.origin
				
		if(playercurrentroom == "back"):
				get_parent().get_parent().get_node("Kinemonster").global_transform.origin = get_node("back").global_transform.origin


		if(get_node("AnimationPlayer").is_playing() == false):
			if(playercurrentroom == "front"):
				get_parent().get_parent().currentroom = backroom
				playercurrentroom = "back"
				get_tree().current_scene.find_node(frontroom).visible = false
			else:
				playercurrentroom = "front"
				get_tree().current_scene.find_node(backroom).visible = false
				get_parent().get_parent().currentroom = frontroom
				
			get_parent().get_parent().get_node("Kinemonster").mode = ""
			_used = 0
			set_process(false)
			
			
func _on_Areafront_body_entered(body):
	if(body.has_method("_on_J2_pressed") and _used == 0):
		playercurrentroom = "front"
		get_parent().get_parent().get_node("Kinemonster").closeobject = self
		get_parent().get_parent().get_node("Kinemonster")._updatehud()

func _on_Areafront_body_exited(body):
	if(body.has_method("_on_J2_pressed") and _used == 0):
		playercurrentroom = ""
		get_parent().get_parent().get_node("Kinemonster").closeobject = null
		get_parent().get_parent().get_node("Kinemonster")._updatehud()

func _on_Areaback_body_entered(body):
	if(body.has_method("_on_J2_pressed") and _used == 0):
		playercurrentroom = "back"
		get_parent().get_parent().get_node("Kinemonster").closeobject = self
		get_parent().get_parent().get_node("Kinemonster")._updatehud()

func _on_Areaback_body_exited(body):
	if(body.has_method("_on_J2_pressed") and _used == 0):
		playercurrentroom = ""
		get_parent().get_parent().get_node("Kinemonster").closeobject = null
		get_parent().get_parent().get_node("Kinemonster")._updatehud()


func _dooricon():
	pass
