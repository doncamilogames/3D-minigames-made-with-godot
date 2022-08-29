extends Area


var ammonb = 10
func _ready():
	pass 


func _on_gungrabable_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"and body.mode != "stopcar"):
				
				if(Global.gtc.modeselected == "Arcade"):
					if(Global.gtc.Arcadeinventory.find("gun") ==-1):
						Global.gtc.Arcadeinventory.append("gun")
					if(Global.gtc.Arcadeammogun < Global.gtc.ammogunmax):
						Global.gtc.Arcadeammogun += ammonb
						if( Global.gtc.Arcadeammogun > Global.gtc.ammogunmax ):
							Global.gtc.Arcadeammogun = Global.gtc.ammogunmax
					get_tree().current_scene.find_node("Kinemacron")._updatehud()

				if(Global.gtc.modeselected == "Gstory"):
					if(Global.gtc.Gstoryinventory.find("gun") ==-1):
						Global.gtc.Gstoryinventory.append("gun")
					if(Global.gtc.Gstoryammogun < Global.gtc.ammogunmax):
						Global.gtc.Gstoryammogun += ammonb
						if( Global.gtc.Gstoryammogun > Global.gtc.ammogunmax ):
							Global.gtc.Gstoryammogun = Global.gtc.ammogunmax
					get_tree().current_scene.find_node("Kinemacron")._updatehud()


				if(Global.gtc.modeselected == "Zombie"):
					if( body.phone != "calling" and body.phone != "called"):
						if(Global.gtc.Zombieinventory.find("gun") ==-1):
							Global.gtc.Zombieinventory.append("gun")
							get_tree().current_scene.get_node("KineFPS")._getobj("gun")
						if(Global.gtc.Zombieammogun < Global.gtc.ammogunmax):
							Global.gtc.Zombieammogun += ammonb
							get_tree().current_scene.get_node("KineFPS")._getobj("gunammo")
							if( Global.gtc.Zombieammogun > Global.gtc.ammogunmax ):
								Global.gtc.Zombieammogun = Global.gtc.ammogunmax
						get_tree().current_scene.find_node("KineFPS")._updatehud()

				get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
				get_tree().current_scene.get_node("sound").play()
				queue_free()

