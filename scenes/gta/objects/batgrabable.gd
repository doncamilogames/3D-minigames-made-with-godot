extends Area



func _ready():
	pass 


func _on_batgrabable_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"and body.mode != "stopcar"):
				if(Global.gtc.modeselected == "Arcade"):
					if(Global.gtc.Arcadeinventory.find("bat") ==-1):
						Global.gtc.Arcadeinventory.append("bat")
						get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
						get_tree().current_scene.get_node("sound").play()
						queue_free()

				if(Global.gtc.modeselected == "Gstory"):
					if(Global.gtc.Gstoryinventory.find("bat") ==-1):
						Global.gtc.Gstoryinventory.append("bat")
						get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
						get_tree().current_scene.get_node("sound").play()
						queue_free()




				if(Global.gtc.modeselected == "Zombie"):
					if( body.phone != "calling" and body.phone != "called"):
						if(Global.gtc.Zombieinventory.find("bat") ==-1):
							get_tree().current_scene.get_node("KineFPS")._getobj("bat")
							get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
							get_tree().current_scene.get_node("sound").play()
							queue_free()

