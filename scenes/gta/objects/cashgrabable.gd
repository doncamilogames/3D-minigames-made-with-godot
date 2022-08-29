extends Area


var cashnb = 5
func _ready():
	pass 

func _on_cashgrabable_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "stopcar"):
				if(Global.gtc.modeselected == "Arcade"):
					Global.gtc.Arcadecash += cashnb
					get_tree().current_scene.find_node("Kinemacron")._updatehud()
				if(Global.gtc.modeselected == "Gstory"):
					Global.gtc.Gstorycash += cashnb
					get_tree().current_scene.find_node("Kinemacron")._updatehud()
				if(Global.gtc.modeselected == "Zombie"):
						get_tree().current_scene.get_node("KineFPS")._getobj("cash")
						Global.gtc.Zombiecash += cashnb
						get_tree().current_scene.find_node("KineFPS")._updatehud()
				get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
				get_tree().current_scene.get_node("sound").play()
				queue_free()
