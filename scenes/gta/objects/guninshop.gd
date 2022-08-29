extends Area

export var _kind = ""
var mainnode

var prices = {
	"Gun" : 100,
	"Gun bullets" : 20,
	"Machine Gun" : 300,
	"Machine Gun bullets" : 40,
	"Bat" : 100,
	"Armor" : 300,
	"Food" : 10,
}
var descs = {
	"Gun" : "Our best selling! ",
	"Gun bullets" : "10 bullets for 20$!",
	"Machine Gun" : "You have not succeded in your life until you have one of those.",
	"Machine Gun bullets" :  "20 bullets for 40$!",
	"Bat" : "It's expensive because of the non-lethal weapons tax...",
	"Armor" :  "I even sleep with an armor like this, very comfortable.",
	"Food" : "Refills all your life instantly! ",
}

func _ready():
	mainnode = get_parent()
	for i in get_children():
		if(i.name == _kind or i.name == "CollisionShape"):
			pass
		else:
			i.queue_free()

func _shop():
	if(Global.gtc.modeselected == "Arcade"):
		if(Global.gtc.Arcadecash >= prices.get(_kind) ):
			if(_kind == "Gun"):
				if(Global.gtc.Arcadeinventory.find("gun") == -1):
					Global.gtc.Arcadeinventory.append("gun")
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "gun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()
			if(_kind == "Gun bullets"):
				if(Global.gtc.Arcadeammogun < Global.gtc.ammogunmax and Global.gtc.Arcadeinventory.find("gun") != -1 ):
					Global.gtc.Arcadeammogun += 10
					if (Global.gtc.Arcadeammogun > Global.gtc.ammogunmax ):
						Global.gtc.Arcadeammogun = Global.gtc.ammogunmax
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "gun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()

			if(_kind == "Machine Gun"):
				if(Global.gtc.Arcadeinventory.find("mgun") == -1):
					Global.gtc.Arcadeinventory.append("mgun")
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "mgun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()

			if(_kind == "Machine Gun bullets"):
				if(Global.gtc.Arcadeammomgun < Global.gtc.ammomgunmax and Global.gtc.Arcadeinventory.find("mgun") != -1):
					Global.gtc.Arcadeammomgun += 20
					if (Global.gtc.Arcadeammomgun > Global.gtc.ammomgunmax ):
						Global.gtc.Arcadeammomgun = Global.gtc.ammomgunmax
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "mgun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()

			if(_kind == "Bat"):
				if(Global.gtc.Arcadeinventory.find("bat") == -1):
					Global.gtc.Arcadeinventory.append("bat")
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "bat"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()


			if(_kind == "Armor"):
				if(Global.gtc.Arcadecurrentarmor < Global.gtc.armormax):
					Global.gtc.Arcadecurrentarmor =500
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.get_node("Kinemacron/macronwithgun/Armature/Bone/Bone001/armor").visible = true
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()


			if(_kind == "Food"):
				if(Global.gtc.Arcadecurrentlife < Global.gtc.lifemax):
					Global.gtc.Arcadecurrentlife = Global.gtc.lifemax
					Global.gtc.Arcadecash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()

		else:
			mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
			mainnode.get_node("sound").play()

	if(Global.gtc.modeselected == "Gstory"):
		if(Global.gtc.Gstorycash >= prices.get(_kind) ):
			if(_kind == "Gun"):
				if(Global.gtc.Gstoryinventory.find("gun") == -1):
					Global.gtc.Gstoryinventory.append("gun")
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "gun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()
			if(_kind == "Gun bullets"):
				if(Global.gtc.Gstoryammogun < Global.gtc.ammogunmax and Global.gtc.Gstoryinventory.find("gun") != -1 ):
					Global.gtc.Gstoryammogun += 10
					if (Global.gtc.Gstoryammogun > Global.gtc.ammogunmax ):
						Global.gtc.Gstoryammogun = Global.gtc.ammogunmax
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "gun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()

			if(_kind == "Machine Gun"):
				if(Global.gtc.Gstoryinventory.find("mgun") == -1):
					Global.gtc.Gstoryinventory.append("mgun")
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "mgun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()

			if(_kind == "Machine Gun bullets"):
				if(Global.gtc.Gstoryammomgun < Global.gtc.ammomgunmax and Global.gtc.Gstoryinventory.find("mgun") != -1):
					Global.gtc.Gstoryammomgun += 20
					if (Global.gtc.Gstoryammomgun > Global.gtc.ammomgunmax ):
						Global.gtc.Gstoryammomgun = Global.gtc.ammomgunmax
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "mgun"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()

			if(_kind == "Bat"):
				if(Global.gtc.Gstoryinventory.find("bat") == -1):
					Global.gtc.Gstoryinventory.append("bat")
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.currentweapon = "bat"
					mainnode.get_node("Kinemacron")._changegun()
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()


			if(_kind == "Armor"):
				if(Global.gtc.Gstorycurrentarmor < Global.gtc.armormax):
					Global.gtc.Gstorycurrentarmor =500
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()
					mainnode.get_node("Kinemacron/macronwithgun/Armature/Bone/Bone001/armor").visible = true
				else:
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
					mainnode.get_node("sound").play()


			if(_kind == "Food"):
				if(Global.gtc.Gstorycurrentlife < Global.gtc.lifemax):
					Global.gtc.Gstorycurrentlife = Global.gtc.lifemax
					Global.gtc.Gstorycash -= prices.get(_kind)
					mainnode.get_node("Kinemacron")._updatehud()
					mainnode.get_node("sound").set_stream( preload("res://asset/sounds/buy.wav"))
					mainnode.get_node("sound").play()

		else:
			mainnode.get_node("sound").set_stream( preload("res://asset/sounds/voicehited.wav"))
			mainnode.get_node("sound").play()






func _on_guninshop_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		if(body.mode != "car"and body.mode != "stopcar"):
			mainnode.closeobject = self
			mainnode._closeobject("shop")
			mainnode._opendshoptextbox()


func _on_guninshop_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		if(body.mode != "car"and body.mode != "stopcar"):
			mainnode.closeobject = null
			mainnode._closeobject("null")
			mainnode._closedshoptextbox()
