extends Area



var ammonb = 20
func _ready():
	pass 

func _on_mgungrabable_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"and body.mode != "stopcar"):
				
				if(Global.gtc.modeselected == "Arcade"):
					if(Global.gtc.Arcadeinventory.find("mgun") ==-1):
						Global.gtc.Arcadeinventory.append("mgun")
					if(Global.gtc.Arcadeammomgun < Global.gtc.ammomgunmax):
						Global.gtc.Arcadeammomgun += ammonb
						if( Global.gtc.Arcadeammomgun > Global.gtc.ammomgunmax ):
							Global.gtc.Arcadeammomgun = Global.gtc.ammomgunmax
					get_tree().current_scene.find_node("Kinemacron")._updatehud()

				if(Global.gtc.modeselected == "Gstory"):
					if(Global.gtc.Gstoryinventory.find("mgun") ==-1):
						Global.gtc.Gstoryinventory.append("mgun")
					if(Global.gtc.Gstoryammomgun < Global.gtc.ammomgunmax):
						Global.gtc.Gstoryammomgun += ammonb
						if( Global.gtc.Gstorymmomgun > Global.gtc.ammomgunmax ):
							Global.gtc.Gstoryammomgun = Global.gtc.ammomgunmax
					get_tree().current_scene.find_node("Kinemacron")._updatehud()

				if(Global.gtc.modeselected == "Zombie"):
					if( body.phone != "calling" and body.phone != "called"):
						if(Global.gtc.Zombieinventory.find("mgun") ==-1):
							Global.gtc.Zombieinventory.append("mgun")
							get_tree().current_scene.get_node("KineFPS")._getobj("mgun")
						if(Global.gtc.Zombieammomgun < Global.gtc.ammomgunmax):
							Global.gtc.Zombieammomgun += ammonb
							get_tree().current_scene.get_node("KineFPS")._getobj("mgunammo")
							if( Global.gtc.Zombieammomgun > Global.gtc.ammomgunmax ):
								Global.gtc.Zombieammomgun = Global.gtc.ammomgunmax
								
						get_tree().current_scene.find_node("KineFPS")._updatehud()





				get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
				get_tree().current_scene.get_node("sound").play()
				queue_free()

