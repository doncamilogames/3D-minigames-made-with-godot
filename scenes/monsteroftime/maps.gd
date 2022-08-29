extends Spatial
var currentroom = ""
var talker
func _ready():


	if(name == "boatinside"):
		if(Global.mot.switch.find("introcut") == -1):
			get_node("cutscene").play("introboat")
			get_node("Kinemonster").mode = "cutscene"
			get_node("Kinemonster")._showhidehud("hide")
			return
		else:
			get_node("npc/friend1").queue_free()
			get_node("npc/friend2").queue_free()
			get_node("npc/sagnol").queue_free()
			get_node("Kinemonster").get_node("Spring/SpringArm/Camera").current = true

	if(name == "beach"):
		if(Global.mot.switch.find("introcut2") == -1):
			get_node("cutscene").play("introbeach")
			get_node("Kinemonster")._showhidehud("hide")
			get_node("Kinemonster").mode = "cutscene"
		else:
			get_node("ground/Audiomusic").set_stream(load("res://asset/sounds/beach.ogg"))
			get_node("ground/Audiomusic").set_pitch_scale(1.0)
			get_node("ground/Audiomusic").play()
			get_node("npc/sagnol").queue_free()
			get_node("Kinemonster/Spring/SpringArm/Camera").current = true
			if(Global.mot.switch.find("introcut3") == -1):# begining, friends near portal
				get_node("npc/friend1").global_transform.origin = Vector3(100,13.8,-70.3)
				get_node("npc/friend2").global_transform.origin = Vector3(95.5,13.8,-80)
				get_node("npc/chief").global_transform.origin = Vector3(99,13.8,-76.3)

			else:#when friends are gone, only chief
				get_node("npc/friend1").queue_free()
				get_node("npc/friend2").queue_free()
				get_node("npc/chief").global_transform.origin = Vector3(99,13.8,-76.3)



	if(name == "rihouse"):
		if(Global.mot.switch.find("rihouse") == -1):
			get_node("cutscene").play("rihouse")
			get_node("Kinemonster")._showhidehud("hide")
			get_node("Kinemonster").mode = "cutscene"
		else:
			get_node("Kinemonster/Spring/SpringArm/Camera").current = true

	if( Global.mot.spawn != ""):
		Global.mot.lastspawn =  Global.mot.spawn
		Global.mot.lastscene =  name

		get_node("Kinemonster").global_transform.origin = get_tree().current_scene.find_node(Global.mot.spawn).global_transform.origin
		get_node("Kinemonster").rotation_degrees.y = get_tree().current_scene.find_node(Global.mot.spawn).rotation_degrees.y
		if("inside" in name):
			if(get_tree().current_scene.find_node(Global.mot.spawn).get_parent()._room != ""):
				_changeroom(get_tree().current_scene.find_node(Global.mot.spawn).get_parent()._room)

		Global.mot.spawn = ""
		Global.mot.changescene = ""
		
	else:
		if("inside" in name):
			_changeroom("room1")
		get_node("Kinemonster").global_transform.origin = get_tree().current_scene.find_node(Global.mot.lastspawn).global_transform.origin    
		get_node("Kinemonster").rotation_degrees.y = get_tree().current_scene.find_node(Global.mot.lastspawn).rotation_degrees.y
	Global._savegame()

func _changeroom(newroom):
	for i in get_children():
		if("room" in i.name):
			if(i.name == newroom):
				i.visible = true
			else:
				i.visible = false

func _bag(what):
	if(what == "open"):
		get_tree().call_group("enemies","_pause")
		get_tree().call_group("npc","_pause")
	elif(what == "close"):
		get_tree().call_group("enemies","_unpause")
		get_tree().call_group("npc","_unpause")

func cutsceneaction(who, what):
	get_tree().current_scene.find_node(who,true,false)._playanim(what)

func _talk(what):
	if(what == "stop"):
		get_node("Kinemonster").mode = ""
		_closetextbox()
		get_node("Kinemonster/text/bg").visible = false
		get_node("Kinemonster/text/Label").visible_characters = 0
		get_node("Kinemonster/text/textspeed").stop()
	else:
		get_node("Kinemonster").mode = "talking"
		_opendtalkbox(what)

func _closetextbox():
	get_node("Kinemonster/text/bg").visible = false
	get_node("Kinemonster/text/Label").visible_characters = 0

func _opendtextbox(_text):
	get_node("Kinemonster/text/bg").visible = true
	get_node("Kinemonster/text/Label").visible_characters = 0
	get_node("Kinemonster/text/Label").set_bbcode(get_node("Kinemonster/text").cutscenetext.get(_text))
	get_node("Kinemonster/text/textspeed").start()
	if(get_node("Kinemonster/text").cutscenanim.get(_text) != ""):#
		talker = get_tree().current_scene.find_node(get_node("Kinemonster/text").cutscenanim.get(_text),true,false)
		talker._playanim("talk")

	var talkervoice = get_node("Kinemonster/text").cutscenvoice.get(_text)
	get_node("Kinemonster/text/voice").set_stream(get_node("Kinemonster/text").voices.get(talkervoice))

func _opendtalkbox(_type):
	get_node("Kinemonster/text/bg").visible = true
	get_node("Kinemonster/text/Label").visible_characters = 0
	var dict = get_node("Kinemonster/text").get(_type)
	for i in dict :
		if(Global.mot.switch.find(i) != -1) :
			get_node("Kinemonster/text/Label").set_bbcode(get_node("Kinemonster/text").get(_type).get(i)  )
			get_node("Kinemonster/text/textspeed").start()
			if(get_node("Kinemonster/text").cutscenanim.get(_type) != ""):#
				talker = get_tree().current_scene.find_node(_type,true,false)
				talker._playanim("talk")

			get_node("Kinemonster/text/voice").set_stream(get_node("Kinemonster/text").voices.get(_type))



func _on_textspeed_timeout():
	get_node("Kinemonster/text/Label").visible_characters +=1
	if(get_node("Kinemonster/text/voice").is_playing() == false):
		get_node("Kinemonster/text/voice").play()
	talker._playanim("mouth")
	if(get_node("Kinemonster/text/Label").visible_characters < get_node("Kinemonster/text/Label").get_total_character_count()):
			get_node("Kinemonster/text/textspeed").start()

func _endcutscene():#only for cutscene intro
	get_node("cutscene").stop()
	get_node("Kinemonster")._showhidehud("show")
	get_node("Kinemonster/Spring/SpringArm/Camera").current = true
	get_node("Kinemonster/text/bg").visible = false
	get_node("Kinemonster/text/Label").visible_characters = 0
	get_node("Kinemonster/text/textspeed").stop()
	get_node("pos/Animtransition").play("fadein")
	Global._savegame()
	get_node("Kinemonster").mode = ""

	if(name == "boatinside"):
			get_node("npc/friend1").queue_free()
			get_node("npc/friend2").queue_free()
			get_node("npc/sagnol").queue_free()
			get_node("Kinemonster").global_transform.origin = Vector3(0.549,0,-7.335)
			Global.mot.switch.append("introcut")

	if(name == "beach"):
			get_node("Kinemonster").global_transform.origin = Vector3(95.5,12.13,-69.335)
			Global.mot.switch.append("introcut2")
			get_node("npc/sagnol").queue_free()

			get_node("ground/Audiomusic").set_stream(load("res://asset/sounds/beach.ogg"))
			get_node("ground/Audiomusic").set_pitch_scale(1.0)
			get_node("ground/Audiomusic").play()

			if(Global.mot.switch.find("introcut3") == -1):# begining, friends near portal
				get_node("npc/friend2").global_transform.origin = Vector3(100,13.8,-70.3)
				get_node("npc/friend1").global_transform.origin = Vector3(95.5,13.8,-80)
				get_node("npc/chief").global_transform.origin = Vector3(99,13.8,-76.3)

			else:#when friends are gone, only chief
				get_node("npc/friend1").queue_free()
				get_node("npc/friend2").queue_free()
				get_node("npc/chief").global_transform.origin = Vector3(99,13.8,-76.3)

	if(name == "rihouse"):
		Global.mot.switch.append("rihouse") 


func _on_Arealight_body_entered(body):# if you need area with custom things
	if(name == "rihouse"):
		if(body.has_method("_on_J2_pressed")):
			get_node("ground/DirectionalLight").visible = false
		
func _on_Arealight_body_exited(body):
	if(name == "rihouse"):
		if(body.has_method("_on_J2_pressed")):
			get_node("ground/DirectionalLight").visible = true
		
