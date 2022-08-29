extends KinematicBody
# Physics
#export(float, 0.1, 3.0, 0.1) var gravity_scl = 1.0
onready var ground_ray = $GroundRay
onready var Animleg = get_node("meshfps/leg")
onready var Animarm = get_node("meshfps/arm")
onready var Animgun = get_node("meshfps/gun")
onready var rng = RandomNumberGenerator.new()




var move = 0
var gravity_speed = 0
var run = 0
var accel = 1.0
var speedtemp = 0.0
var speed = 5.0
var speedturn = 4.0
var acceleration = 1.0
var forward_speed = 0.0
var velocity = Vector3()
onready var impactobject 
var phone = "close"
var calling = ""

var currenttime = 0.0
var tempmin


#var life = 1000.0
var mode = "" # car, startcar
var keyboarddir = Vector3()
var dirpad = Vector2()
var running = 0
var falling = 0

var delaydoor = 0
#TIME
var ingames =  79200 # 79200 = 22h in seconds
var ingamem 
var ingameh 



func _ready():
	currenttime = Global.gtc.Zombietime
	get_node("meshfps/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,load("res://scenes/gta/npc/faceF1.tres"))
	var clotharray = [get_node("meshfps/Armature/Bone/Bone001/chest"),get_node("meshfps/Armature/Bone/hips"),get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("meshfps/Armature/Bone/Bone001/Bone003/armr"),get_node("meshfps/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("meshfps/Armature/Bone/Bone001/Bone006/arml"),get_node("meshfps/Armature/Bone/Bone009/ulegr"),get_node("meshfps/Armature/Bone/Bone009/Bone010/blegr"),get_node("meshfps/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("meshfps/Armature/Bone/Bone012/ulegl"),get_node("meshfps/Armature/Bone/Bone012/Bone013/blegl"),get_node("meshfps/Armature/Bone/Bone012/Bone013/Bone014/footl")]
	for i in clotharray :
		i.set_surface_material(0,load("res://asset/materials/clothnpc5.tres"))

	if(get_parent().name == "GTATown"):
		if(Global.gtc.Zombielastspawn != ""):

			global_transform.origin = get_tree().current_scene.find_node(Global.gtc.Zombielastspawn,true,false).global_transform.origin
	else:
		get_node("minimap/pointer").position.x = Global.gtc.Zombiecurrentpos[0]
		get_node("minimap/pointer").position.y = Global.gtc.Zombiecurrentpos[1]
		if(Global.gtc.spawnpoint != ""):
			global_transform.origin = get_tree().current_scene.find_node(Global.gtc.spawnpoint).global_transform.origin
	rng.randomize()


#	Animarm.play("holdgun")
#	_showhidehud("hide")

	if(Global.gtc.get(Global.gtc.modeselected + "currentarmor") > 0):
		get_node("meshfps/Armature/Bone/Bone001/armor").visible = true
	_updatehud()
	_updateminimap()

func _showhidehud(what):
	if(what == "hide"):
		get_node("Sprite").visible = false
		get_node("J2").visible = false
		get_node("C").visible = false
		get_node("A").visible = false
		get_node("gun").visible = false
		get_node("Virtual joystick").visible = false
		get_node("B").visible = false
		get_node("phone").visible = false
		get_node("hud").visible = false
	if(what == "show"):
		if(Global.gtc.Zombiecurrentweapon == "gun" or Global.gtc.Zombiecurrentweapon == "gun"):
			get_node("Sprite").visible = true
		get_node("J2").visible = true
		get_node("C").visible = true
		get_node("A").visible = true
		get_node("gun").visible = true
		get_node("Virtual joystick").visible = true
		get_node("hud").visible = true
		get_node("B").visible = true
		get_node("phone").visible = true
		
func _updatehud():
	if(Global.gtc.Zombiegoods.find("sister") != -1):
		get_node("hud/sisterlife/bar").scale.x = Global.gtc.Zombierelativ.get("sister")[4] / 1000.0
	if(Global.gtc.Zombiegoods.find("father") != -1):
		get_node("hud/fatherlife/bar").scale.x = Global.gtc.Zombierelativ.get("father")[4] / 1000.0
	if(Global.gtc.Zombiegoods.find("brother") != -1):
		get_node("hud/brotherlife/bar").scale.x = Global.gtc.Zombierelativ.get("brother")[4] / 1000.0
	if(Global.gtc.Zombiegoods.find("mother") != -1):
		get_node("hud/motherlife/bar").scale.x = Global.gtc.Zombierelativ.get("mother")[4] / 1000.0
		
	get_node("hud/life/bar").scale.x = Global.gtc.Zombiecurrentlife / Global.gtc.lifemax
	get_node("hud/life/armor").scale.x = Global.gtc.Zombiecurrentarmor / Global.gtc.armormax
	if(Global.gtc.Zombiecurrentweapon == "gun"):
		get_node("hud/weapon/ammo").set_text(str(Global.gtc.Zombieammogun))
	elif(Global.gtc.Zombiecurrentweapon == "mgun"):
		get_node("hud/weapon/ammo").set_text(str(Global.gtc.Zombieammomgun))

	if(currenttime < 7200):
		ingames = currenttime + 79200 # 79200 = 22h in seconds
		ingamem = floor(ingames / 60)
		ingameh = floor(ingamem / 60)
		ingamem =floor( fmod(ingamem,60))
		get_node("phone/time").set_text(str(ingameh).pad_zeros(2) + ":" + str(ingamem).pad_zeros(2))
	else:
		ingames = currenttime - 7200 # after midnight
		ingamem = floor(ingames / 60)
		ingameh = floor(ingamem / 60)
		get_node("phone/time").set_text(str(ingameh).pad_zeros(2) + ":" + str(fmod(ingamem,60)).pad_zeros(2))
				# MANAGE EVENTS
	if(get_parent().started == 1):
		if(ingameh  == 23): # Father change place
			if(Global.gtc.Zombierelativ.get("father")[1] ==  "road"):
				Global.gtc.Zombierelativ.get("father")[1] =  "home"
				Global.gtc.Zombierelativ.get("father")[2] =  "parent"
				
			if(Global.gtc.Zombieswitch.find("1stcallparents") == -1):
				if(phone == "close" or phone == "light"): #CALL PLAYER TO COME
					if( get_node("bag").visible == false):
						get_node("SpotLight").visible = false
						phone = "calledparents1st"
						Global.gtc.Zombieswitch.append("1stcallparents")
						get_node("phone/AnimationPlayer").play("phone")
						get_node("phone/AnimationPlayer").queue("call")
						get_node("phone/called").visible = true
						get_node("phone/called/label").set_text("Father\nCall")
						get_node("phone/AudioStreamPlayer").play()

		elif(ingameh  == 1): # MOTHER DIE IF NOT HELPED
			if(Global.gtc.Zombieswitch.find("parenthelp") == -1):
				if(Global.gtc.Zombieswitch.find("motherdead") == -1):
					if(phone == "close"  or phone == "light"):
						if(get_node("bag").visible == false): #CALL PLAYER TO ANOUNCE MOTHER DEATH
							get_node("SpotLight").visible = false
							phone = "calledmotherdead"
							Global.gtc.Zombieswitch.append("motherdead")
							get_node("phone/AnimationPlayer").play("phone")
							get_node("phone/AnimationPlayer").queue("call")
							get_node("phone/called").visible = true
							get_node("phone/called/label").set_text("Father\nCall")
							get_node("phone/AudioStreamPlayer").play()
							Global.gtc.Zombierelativ.get("mother")[0] = "dead"
							Global.gtc.Zombierelativ.get("mother")[1] = "dead"
							Global.gtc.Zombierelativ.get("mother")[2] = "dead"
							if(Global.gtc.Zombieswitch.find("parentmet") == -1):
								Global.gtc.Zombierelativ.get("father")[3] = "father11"
							else:
								Global.gtc.Zombierelativ.get("father")[3] = "father9"


#	elif(ingameh  == 2): # SISTER CALL PLAYER IF NEVER DONE
#		if(Global.gtc.Zombieswitch.find("1stcallsister") == -1):
#			if(phone == "close" or phone == "light"):
#				if(get_node("bag").visible == false): #CALL PLAYER TO COME
#					get_node("SpotLight").visible = false
#					phone = "calledsister1st"
#					Global.gtc.Zombieswitch.append("1stcallsister")
#					get_node("phone/AnimationPlayer").play("phone")
##					get_node("phone/AnimationPlayer").queue("call")
	#				get_node("phone/called").visible = true
	#				get_node("phone/called/label").set_text("Sister\nCall")
	#				get_node("phone/AudioStreamPlayer").play()

#	elif(ingameh  == 3): # SISTER GO TO HER HOME
#	elif(ingameh  == 4): #  PARENTS GO PORT (OR AIRPORT IF SISTER) / SISTER DIE IF NOT HELPED
#	elif(ingameh  == 5): #  PARENT AT PORT / BROTHER  DIE IF NOT HELPED


	if(get_node("bag").visible == true):
		var foodnb = 0
		var sodanb = 0
		var mednb = 0
		for i in Global.gtc.Zombiegoods:
			if(i == "food"):
				foodnb += 1
			elif(i == "soda"):
				sodanb += 1
			elif(i == "medecine"):
				mednb += 1
		get_node("bag/inventory/Goods/food/amount").set_text(str(foodnb))
		get_node("bag/inventory/Goods/drink/amount").set_text(str(sodanb))
		get_node("bag/inventory/Goods/medicine/amount").set_text(str(mednb))
		



		if(Global.gtc.Zombieinventory.find("bat") != -1):
			get_node("bag/inventory/weapons/bat").visible = true
		if(Global.gtc.Zombieinventory.find("gun") != -1):
			get_node("bag/inventory/weapons/gun").visible = true
			get_node("bag/inventory/weapons/gun/Label").set_text(str(Global.gtc.Zombieammogun))
		if(Global.gtc.Zombieinventory.find("mgun") != -1):
			get_node("bag/inventory/weapons/mgun").visible = true
			get_node("bag/inventory/weapons/mgun/Label").set_text(str(Global.gtc.Zombieammomgun))

func _playanim(what):
	if what == "talk":
		get_node("meshfps/arm").play("shakehand",-1,0.1)
	if what == "mouth":
		get_node("meshfps/mouth").play("mouth")
	if what == "walk":
		get_node("meshfps/leg").play("Walk")
	if what == "onchair":
		get_node("meshfps/leg").play("Idleonchair")
	if what == "tophand":
		get_node("meshfps/leg").play("tophand")
	if what == "climbwall":
		get_node("meshfps/leg").play("climbwall")
	if what == "swim":
		get_node("meshfps/leg").play("swimidle")
	if what == "idle":
		get_node("meshfps/leg").play("IdleAll")
	if what == "idleanim":
		get_node("meshfps/leg").play("Idleanimated")
	if what == "onknees":
		get_node("mesh/Animleg").play("onknees")
	if what == "sit":
		get_node("mesh/Animleg").play("sitonchair")
		
func _process(delta):
	dirpad = Vector2(Input.get_joy_axis(0,JOY_ANALOG_LX),Input.get_joy_axis(0,JOY_ANALOG_LY) ) #JOYSTICK
	if(abs(dirpad.x) + abs(dirpad.y) < 0.7):#DEADZONE
			dirpad = Vector2.ZERO
			
			
	if(get_parent().started == 1): #MANAGE TME, update hud only when need
		tempmin = floor(currenttime / 60)
		currenttime += (delta * 8 )
		if(tempmin != floor(currenttime / 60)):
			Global.gtc.Zombietime = currenttime
			_updatehud()
			

	if(get_node("gun").is_pressed() == true):
		if(running == 0 and get_node("bag").visible == false):
			_shoot()


	if(Animgun.is_playing() == false):
		if(Animarm.is_playing() == false):
			Animarm.play("holdgun",0.2)

	if(phone == "map"):
		if(get_parent().name == "GTATown"):
			get_node("minimap/pointer").position = Vector2(global_transform.origin.x / 1.831, global_transform.origin.z /3.527 )

	if(get_parent().name == "GTATown"):
		if(get_parent().npcnear < get_parent().maxnpc):			#NPC SPAWNNNNN
			if(get_parent().justspawn == 0): 
				if(get_node("npc/RayCast").get_collider() != null):
					get_parent()._spawnnpc(get_node("npc/RayCast").get_collision_point())
					
		if(get_parent().carnear < get_parent().maxcar and get_parent().justspawncar == 0): 			#CARS SPAWNNNNN
			if(get_node("npc/RayCastCar").get_collider() != null):
				get_parent()._spawncar(get_node("npc/RayCastCar").get_collision_point())



	if( mode == "" ):
		if(keyboarddir != Vector3.ZERO) :    #   KEYBOARD  MOVMENTS  
			move = 1
			rotation_degrees.y = rotation_degrees.y - keyboarddir.x  * speedturn
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			if(keyboarddir.z < 0.0):
				forward_speed = keyboarddir.z * speedtemp
				Animleg.play("Walk",-1,2.0)
			else: #backward
				Animleg.play("Walk",-1,2.0)
				forward_speed =( keyboarddir.z * speedtemp) / 2
			velocity = transform.basis.z * forward_speed *-1

		elif(get_node("Virtual joystick")._output != Vector2.ZERO):#phone move
			rotation_degrees.y = rotation_degrees.y - get_node("Virtual joystick")._output.x  * speedturn
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			if(get_node("Virtual joystick")._output.y < 0.0):
				forward_speed = get_node("Virtual joystick")._output.y * speedtemp
				Animleg.play("Walk",-1,2.0)
			else: #backward
				Animleg.play("Walk",-1,2.0)
				forward_speed =( get_node("Virtual joystick")._output.y * speedtemp) / 2
			velocity = transform.basis.z * forward_speed *-1
			move = 1
			Animleg.play("Walk",-1,2.0)

		elif(dirpad != Vector2.ZERO):#pad move
			rotation_degrees.y = rotation_degrees.y - dirpad.x  * speedturn
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			if(dirpad.y < 0.0):
				forward_speed = dirpad.y * speedtemp
				Animleg.play("Walk",-1,2.0)
			else: #backward
				Animleg.play("Walk",-1,2.0)
				forward_speed =( dirpad.y * speedtemp) / 2
			velocity = transform.basis.z * forward_speed *-1

			move = 1
			Animleg.play("Walk",-1,2.0)


		else: #don't move
				speedtemp = lerp(speedtemp, 0.0, acceleration ) 
				velocity = lerp(velocity,Vector3.ZERO,0.2)
				move = 0
#				Animleg.play("Idle")
				Animleg.stop()

	elif(mode == "falling" ):
		velocity = Vector3.ZERO
		speedtemp = 0
		if(Animleg.is_playing() == false):
			falling = 0
			mode = "" 

	elif(mode == "dead"):
		velocity = Vector3.ZERO
		get_parent().get_node("Camera/Camera").translation.y -=0.06
		get_parent().get_node("Camera/Camera").rotation_degrees.y += 4
		get_parent().get_node("Camera").global_transform.origin = global_transform.origin
		if(get_parent().get_node("Camera/Camera").translation.y <= 0.0):
			get_tree().change_scene("res://scenes/gta/gtamenu.tscn")

	if(!ground_ray.is_colliding() ):# NOT ON GROUND
		velocity.y = - 10.0

	if(running == 1):
		if(move == 1):
			if(Global.gtc.Zombiecurrentrun > 0):
				Global.gtc.Zombiecurrentrun -= 6
				velocity *= 1.8
				get_node("hud/run/bar").scale.x = Global.gtc.Zombiecurrentrun/ Global.gtc.lifemax
	else:
		if(Global.gtc.Zombiecurrentrun < 1000):
			if(move == 0):
				Global.gtc.Zombiecurrentrun +=2
				get_node("hud/run/bar").scale.x = Global.gtc.Zombiecurrentrun/ Global.gtc.lifemax
			else:
				Global.gtc.Zombiecurrentrun += 0.5
				get_node("hud/run/bar").scale.x = Global.gtc.Zombiecurrentrun/ Global.gtc.lifemax

	move_and_slide(velocity, Vector3(0,1,0))

func _input(event):
	if Input.is_action_just_pressed("Xbutton") == true:
		_on_A_pressed()
		
	if Input.is_action_just_pressed("Abutton") == true:
		_on_J2_pressed()
		
	if( Input.is_action_pressed("Ybutton") == true or get_node("C").is_pressed()):
			running =1
	else:
			running = 0


	if Input.is_action_pressed("Bbutton") == true:
		if(running == 0 and get_node("bag").visible == false):
			_shoot()
			
	keyboarddir = Vector3.ZERO
	if Input.is_action_pressed("ui_up")  == true:  
		keyboarddir -= Vector3(0,0,1) #go foward
	elif Input.is_action_pressed("ui_down"):  
		keyboarddir += Vector3(0,0,1)
	if Input.is_action_pressed("ui_left"):  
		keyboarddir -= Vector3(1,0,0)
	elif Input.is_action_pressed("ui_right"): 
		keyboarddir += Vector3(1,0,0)

	return keyboarddir.normalized()


func _shooted(who,strength):
	if( mode != "dead"):
		if(mode != "car" and mode != "startcar" and mode != "stopcar" ):
			get_node("hud/touched/AnimationPlayer").play("Anim")
			look_at(who.global_transform.origin,Vector3(0,1,0))
			rotation_degrees.y -= 180
			_receivedamage(strength,"weapon")
		else:
			get_parent().closeobject._shooted(who,strength)

func _sworded(strength):
	if( mode != "dead"):
		_receivedamage(strength,"weapon")

func _receivedamage(amount,type):
		get_node("hud/touched/AnimationPlayer").play("Anim")
		if(Global.gtc.Zombiecurrentarmor > 0 ): #if armor
			if(amount > Global.gtc.Zombiecurrentarmor): # armor destroyed
				amount -= Global.gtc.Zombiecurrentarmor
				Global.gtc.Zombiecurrentarmor = 0
				get_node("meshfps/Armature/Bone/Bone001/armor").visible = false
			else: # armor damaged, receive no damage 
				Global.gtc.Zombiecurrentarmor -= amount
				amount = 0
		Global.gtc.Zombiecurrentlife -= amount
		get_node("hud/touched/AnimationPlayer").play("Anim")
		if(Global.gtc.Zombiecurrentlife <= 0):
			get_parent()._endgame()
		_updatehud()


func _on_J2_pressed():# change gun
	
	if( mode != "dead"):
		var temp = Global.gtc.Zombieinventory.find(Global.gtc.Zombiecurrentweapon)
		if(temp+1  < Global.gtc.Zombieinventory.size()  ):
			Global.gtc.Zombiecurrentweapon = Global.gtc.Zombieinventory[temp+1]
		else:
			Global.gtc.Zombiecurrentweapon = Global.gtc.Zombieinventory[0]
		_changegun()

func  _changegun():
		get_node("Sprite").visible = false
		get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = false
		get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = false
		get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/Bone005/mgun").visible = false
		get_node("hud/weapon/ammo").visible = false
		Global.gtc.Zombiecurrentweapon = Global.gtc.Zombiecurrentweapon
		if(Global.gtc.Zombiecurrentweapon == "nothing"):
			get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
			get_node("weaponsound").pitch_scale = 2.0
			get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/hand1.png")
		elif(Global.gtc.Zombiecurrentweapon == "bat"):
			get_node("weaponsound").pitch_scale = 1.0
			get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
			get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = true
			get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/bat.png")
		elif(Global.gtc.Zombiecurrentweapon == "gun"):
			get_node("Sprite").visible = true
			get_node("weaponsound").pitch_scale = 0.8
			get_node("weaponsound").set_stream( preload("res://asset/sounds/tac1.wav"))
			get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = true
			get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/gun.png")
			get_node("hud/weapon/ammo").visible = true
			get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammogun")))
		elif(Global.gtc.Zombiecurrentweapon == "mgun"):
			get_node("Sprite").visible = true
			get_node("weaponsound").pitch_scale = 1.2
			get_node("weaponsound").set_stream( preload("res://asset/sounds/tac1.wav"))
			get_node("meshfps/Armature/Bone/Bone001/Bone003/Bone004/Bone005/mgun").visible = true
			get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/mgun.png")
			get_node("hud/weapon/ammo").visible = true
			get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammomgun")))

func _shoot():
	if(mode == ""):
		if(Global.gtc.Zombiecurrentweapon == "gun" and Global.gtc.get(Global.gtc.modeselected + "ammogun") > 0):
			if(Animgun.is_playing() == false):
				Global.gtc.Zombieammogun -=1
				get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammogun")))
				Animarm.play("holdgun")
				Animgun.play("shoot")
				get_node("weaponsound").play()
				if(get_node("guncast").is_colliding()):
					if(get_node("guncast").get_collider().has_method("_shooted")):
						get_node("guncast").get_collider()._shooted(self, get_parent().weaponstrength.get(Global.gtc.Zombiecurrentweapon))
					if(get_node("guncast").get_collider().is_in_group("breakable")):
						get_node("guncast").get_collider().queue_free()
					impactobject = preload("res://scenes/kinematic/impactobject.tscn").instance()
					get_parent().add_child(impactobject)
					impactobject.global_transform.origin = get_node("guncast").get_collision_point()
					impactobject.scale = Vector3(0.1,0.1,0.1)

		if(Global.gtc.Zombiecurrentweapon == "mgun" and Global.gtc.get(Global.gtc.modeselected + "ammomgun") > 0):
			if(Animgun.is_playing() == false):
				Global.gtc.Zombieammomgun -=1
				get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammomgun")))
				Animarm.play("holdgun")
				Animgun.play("mshoot",-1,3.0)
				get_node("weaponsound").play()
				if(get_node("guncast").is_colliding()):
					if(get_node("guncast").get_collider().has_method("_shooted")):
						get_node("guncast").get_collider()._shooted(self, get_parent().weaponstrength.get(Global.gtc.Zombiecurrentweapon))
					if(get_node("guncast").get_collider().is_in_group("breakable")):
						get_node("guncast").get_collider().queue_free()
					impactobject = preload("res://scenes/kinematic/impactobject.tscn").instance()
					get_parent().add_child(impactobject)
					impactobject.global_transform.origin = get_node("guncast").get_collision_point()
					impactobject.scale = Vector3(0.1,0.1,0.1)


		if(Global.gtc.Zombiecurrentweapon == "nothing"):
			if(Animarm.is_playing() == false):
				Animarm.play("punchfps",0.1,1.0)


		if(Global.gtc.Zombiecurrentweapon == "bat"):
			if(Animarm.is_playing() == false):
				Animarm.play("swordfps",0.1,0.8)


func _on_Areapunch_body_entered(body):
	if(Animarm.current_animation == "punchfps"): 
		if(body.has_method("_shooted") and body.has_method("_zombie") ):
			get_node("weaponsound").play()
			body._shooted(self, get_parent().weaponstrength.get(Global.gtc.Zombiecurrentweapon))
		if(body.is_in_group("breakable")):
			body.queue_free()

func _on_Areabat_body_entered(body):
	if(Animarm.current_animation == "swordfps"):
		if(body.has_method("_shooted") and body.has_method("_zombie")):
			get_node("weaponsound").play()
			body._shooted(self, get_parent().weaponstrength.get(Global.gtc.Zombiecurrentweapon))
		if(body.is_in_group("breakable")):
			body.queue_free()


func _randomobj(): #object given when you look in a car, or esle?
	var what = rng.randi_range(0,15)

	if( what < 7):
		if(what == 1):#5 medecine
			_getobj("medecine")
		elif(what <= 3):#,2,3 food
			_getobj("food")
		elif(what <= 5):#,4,5 drink 
			_getobj("drink")
		elif(what == 6):#,6 gunammo 
			_getobj("gunammo")
		get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
		get_tree().current_scene.get_node("sound").play()
			
	else:
		_getobj("nothing")

func _getobj(what):
	if(what == "cash"):
		get_parent().get_node("text/Label").set_text("You find some cash!")
		Global.gtc.Zombiecash += rng.randi_range(5,20)
	if(what == "gun"): #or ammo if already have
		get_parent().get_node("text/Label").set_text("You find a gun!")
		if(Global.gtc.Zombieinventory.find("gun") ==-1):
			Global.gtc.Zombieinventory.append("gun")
		else:
			if(Global.gtc.Zombieammogun < Global.gtc.ammogunmax):
				Global.gtc.Zombieammogun += 10
				if( Global.gtc.Zombieammogun > Global.gtc.ammogunmax ):
						Global.gtc.Zombieammogun = Global.gtc.ammogunmax
	if(what == "gunammo"):
		get_parent().get_node("text/Label").set_text("You find some bullet for the gun!")
		if(Global.gtc.Zombieammogun < Global.gtc.ammogunmax):
			Global.gtc.Zombieammogun += 10
			if( Global.gtc.Zombieammogun > Global.gtc.ammogunmax ):
					Global.gtc.Zombieammogun = Global.gtc.ammogunmax

	if(what == "mgun"):
		get_parent().get_node("text/Label").set_text("You find a  machine gun!")
		if(Global.gtc.Zombieinventory.find("mgun") ==-1):
			Global.gtc.Zombieinventory.append("mgun")
		else:
			if(Global.gtc.Zombieammomgun < Global.gtc.ammomgunmax):
				Global.gtc.Zombieammomgun += 30
				if( Global.gtc.Zombieammomgun > Global.gtc.ammomgunmax ):
						Global.gtc.Zombieammomgun = Global.gtc.ammomgunmax

		
		
		
	if(what == "mgunammo"):
		get_parent().get_node("text/Label").set_text("You find some bullet for the  machine gun!")
		if(Global.gtc.Zombieammomgun < Global.gtc.ammomgunmax):
			Global.gtc.Zombieammomgun += 10
			if( Global.gtc.Zombieammomgun > Global.gtc.ammomgunmax ):
					Global.gtc.Zombieammomgun = Global.gtc.ammomgunmax


	if(what == "bat"): #or ammo if already have
		get_parent().get_node("text/Label").set_text("You find a bat!")
		if(Global.gtc.Zombieinventory.find("bat") ==-1):
			Global.gtc.Zombieinventory.append("bat")

	if(what == "food"):
		get_parent().get_node("text/Label").set_text("You find some food!")
		Global.gtc.Zombiegoods.append("food")
	if(what == "drink"):
		get_parent().get_node("text/Label").set_text("You find a drink!")
		Global.gtc.Zombiegoods.append("drink")
	if(what == "medicine"):
		get_parent().get_node("text/Label").set_text("You find a medicine!")
		Global.gtc.Zombiegoods.append("medicine")
	if(what == "medecinemother"):
		get_parent().get_node("text/Label").set_text("You find the medicine for your mother!")
		Global.gtc.Zombiegoods.append("medecinemother")
		Global.gtc.Zombieswitch.append("medecinemother")
		
	if(what == "nothing"):
		get_parent().get_node("text/Label").set_text("Nothing here...")





	get_parent().get_node("text/Anim").play("textobj")
	get_tree().current_scene.find_node("KineFPS")._updatehud()



func _on_A_pressed():
	if(get_parent().closeobject != null  and falling == 0 and mode != "dead" and phone != "calling" and phone != "called" ):
		if(get_parent().closeobject.has_method("_door") and delaydoor == 1 ):

				Global.gtc.spawnpoint = get_parent().closeobject._spawn
				if(get_parent().name == "GTATown"):
					Global.gtc.Zombielastspawn = get_parent().closeobject.get_parent().name
				Global.gtc.Zombiecurrentpos =  [global_transform.origin.x / 1.831, global_transform.origin.z /3.527 ]
				Global.gtc.Zombiecurrentscene = get_parent().closeobject._scene
				
				get_tree().change_scene(get_parent().closeobject._scene)
				
				
		elif(get_parent().closeobject.has_method("_intdoor")):
				get_parent().closeobject._open()

		elif(get_parent().closeobject.has_method("_shop")):
				get_parent().closeobject._shop()


		elif(get_parent().closeobject.has_method("_car")):
				if(get_parent().closeobject.nearchest == 1):
					get_parent().closeobject.get_node("Animexplode").play("openchest")
					if( get_node("delaydoor").is_stopped() == true):

						get_node("delaydoor").start()
						if(get_parent().closeobject.checked == 0 ):
							get_parent().closeobject.checked = 1
							_randomobj()
						else:
							_getobj("nothing")

					
		elif(get_parent().closeobject.has_method("_fridge")):
				if( get_node("delaydoor").is_stopped() == true):
						get_parent().closeobject._fridge()
						get_node("delaydoor").start()
						if(get_parent().closeobject.checked == 0 ):
							get_parent().closeobject.checked = 1
						else:
							_getobj("nothing")
				


func _on_Area_body_entered(body):
	pass # Replace with function body.


func _on_delaydoor_timeout():
	delaydoor = 1


func _updateminimap():
	if(Global.gtc.Zombieswitch.find("1stcallparents") != -1):
		get_node("minimap/Viewport/map/places/parenthousemap").visible = true
	if(Global.gtc.Zombieswitch.find("1stcallsister") != -1):
		get_node("minimap/Viewport/map/places/sistermap").visible = true
	if(Global.gtc.Zombieswitch.find("1stcallbrother") != -1):
		get_node("minimap/Viewport/map/places/brotherhousemap").visible = true
	if(Global.gtc.Zombieswitch.find("gotohospital") != -1):
		get_node("minimap/Viewport/map/places/hospitalmap").visible = true
	if(Global.gtc.Zombieswitch.find("sisterhouse") != -1):
		get_node("minimap/Viewport/map/places/sisterhousemap").visible = true
	if(Global.gtc.Zombieswitch.find("gotopolice") != -1):
		get_node("minimap/Viewport/map/places/policemap").visible = true
	if(Global.gtc.Zombieswitch.find("eastport") != -1):
		get_node("minimap/Viewport/map/places/East Portmap").visible = true
	if(Global.gtc.Zombieswitch.find("westport") != -1):
		get_node("minimap/Viewport/map/places/West Portmap").visible = true
	if(Global.gtc.Zombieswitch.find("airport") != -1):
		get_node("minimap/Viewport/map/places/Airportmap").visible = true
		
	for i in get_node("minimap/Viewport/map/obj").get_children(): #obj1, obj2....
		if(Global.gtc.Zombieswitch.find(i.name) != -1):
			i.visible = true
		

#PHONE MENU
func _on_phone_pressed():
	if(get_node("bag").visible == false and get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "close"):
			get_node("phone/AnimationPlayer").play("phone")
			phone = "open"
		elif(phone == "open"):
			get_node("phone/AnimationPlayer").play_backwards("phone")
			phone = "close"
		elif(phone == "map"):
			get_node("phone/AnimationPlayer").play_backwards("map")
			get_node("minimap").visible = false
			get_node("phone/map").visible = true
			get_node("phone/save").visible = true
			get_node("phone/call").visible = true
			get_node("phone/light").visible = true
			phone = "open"
		elif(phone == "call"):
			get_node("phone/AnimationPlayer").play_backwards("call")
			phone = "open"
			get_node("phone/father").visible = false
			get_node("phone/mother").visible = false
			get_node("phone/sister").visible = false
			get_node("phone/brother").visible = false
			get_node("phone/map").visible = true
			get_node("phone/save").visible = true
			get_node("phone/call").visible = true
			get_node("phone/light").visible = true
			
		elif(phone == "calling"):
			get_node("phone/AnimationPlayer").play_backwards("calling")
			#_on_call_pressed()
			phone = "call"
			get_parent()._closetextbox()
			get_node("phone/AudioStreamPlayer").stop()
			get_node("phone/delayrespond").stop()
			
			
		elif(phone == "light"):
			phone = "close"
			get_node("SpotLight").visible = false
			
		elif( "called" in phone ):
			get_node("phone/AudioStreamPlayer").stop()
			get_node("phone/AnimationPlayer").queue("calling")
			get_node("phone/called").visible = false
			get_node("phone/light").visible = false
			if("motherdead" in phone ):
				get_parent()._openphonetextbox("Your mother is dead, come to our house please.", "father") 
				phone = "calling"
			if("sister1st" in phone ):
				get_parent()._openphonetextbox("Hey! I'm all right for now, at my workplace, I'm worried about my husband I will wait some times and try to go to my home to meet him, come here please.", "sister") 
				phone = "calling"
			if("calledparents1st" in phone ):
				get_parent()._openphonetextbox("Hey! I'm fine for now in my house, your mother is sick, come to our house please.", "father") 
				phone = "calling"






func _on_map_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "open"):
			if(get_node("minimap").visible == false):
				get_node("phone/AnimationPlayer").play("map")
				phone = "map"
				get_node("phone/call").visible = false
				get_node("phone/light").visible = false
				_updateminimap()
			else:
				get_node("phone/AnimationPlayer").play_backwards("map")
				phone = "open"

func _on_call_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "open"):
			if(get_node("minimap").visible == false):
				get_node("phone/AnimationPlayer").queue("call")
				phone = "call"
				get_node("phone/father").visible = true
				get_node("phone/mother").visible = true
				get_node("phone/sister").visible = true
				get_node("phone/brother").visible = true
				get_node("phone/map").visible = false
				get_node("phone/save").visible = false
				get_node("phone/call").visible = false
				get_node("phone/light").visible = false
			else:
				get_node("phone/AnimationPlayer").play_backwards("call")
				phone = "open"



func _on_light_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "open"):
				phone = "light"
				get_node("phone/AnimationPlayer").play_backwards("phone")
				get_node("SpotLight").visible = true

func _on_save_pressed():
	Global._savegame()


#PHONE CALL
func _on_father_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "call"):
			get_node("phone/AnimationPlayer").queue("calling")
			phone = "calling"
			calling = "father"
			get_node("phone/delayrespond").wait_time = rng.randf_range(2.0,4.0)
			get_node("phone/delayrespond").start()
			get_node("phone/AudioStreamPlayer").play()

func _on_mother_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "call"):
			get_node("phone/AudioStreamPlayer").play()
			get_node("phone/AnimationPlayer").queue("calling")
			phone = "calling"
			calling = "mother"
			get_node("phone/delayrespond").wait_time = rng.randf_range(2.0,4.0)
			get_node("phone/delayrespond").start()

func _on_brother_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "call"):
			get_node("phone/AudioStreamPlayer").play()
			get_node("phone/AnimationPlayer").queue("calling")
			phone = "calling"
			calling = "brother"
			get_node("phone/delayrespond").wait_time = rng.randf_range(2.0,4.0)
			get_node("phone/delayrespond").start()


func _on_sister_pressed():
	if(get_node("phone/AnimationPlayer").is_playing() == false):
		if(phone == "call"):
			get_node("phone/AudioStreamPlayer").play()
			get_node("phone/AnimationPlayer").queue("calling")
			phone = "calling"
			calling = "sister"
			get_node("phone/delayrespond").wait_time = rng.randf_range(2.0,4.0)
			get_node("phone/delayrespond").start()




func _on_delayrespond_timeout():
	get_node("phone/AudioStreamPlayer").stop()
	if(calling != ""):
		if(Global.gtc.Zombieswitch.find(str(calling+"dead")) != -1):# if  dead
			get_parent()._opendtextbox("noanswer") 
			return
		if(Global.gtc.Zombiegoods.find(calling) != -1):# if  with you
			get_parent()._opendtextbox("noanswer") 
			return
		else:#  state + place(+destination if on road) + "with" & relativ list (if relativ) +  objectif
			var newtext = ""
			var callstates = []
			for i in get_parent().get_node("text").phonetext.state.keys(): # ADD STATE
				if(Global.gtc.Zombierelativ.get(calling)[0] in i):
					callstates.append(i)
			newtext += get_parent().get_node("text").phonetext.state.get(callstates[rng.randi_range(0,callstates.size() -1)])

			var callplaces = []
			for i2 in get_parent().get_node("text").phonetext.place.keys(): # ADD PLACE
				if(Global.gtc.Zombierelativ.get(calling)[1] in i2):
					callplaces.append(i2)
			newtext += get_parent().get_node("text").phonetext.place.get(callplaces[rng.randi_range(0,callplaces.size() -1)]) 

			if("road" in Global.gtc.Zombierelativ.get(calling)[1]):# ADD DESTINATION  only if  on road
				var calldestination = []
				for i3 in get_parent().get_node("text").phonetext.destination.keys():
					if(Global.gtc.Zombierelativ.get(calling)[2] in i3):
						calldestination.append(i3)
				newtext += get_parent().get_node("text").phonetext.destination.get(calldestination[rng.randi_range(0,calldestination.size() -1)]) 

			var callrelativ = []
			for i4 in Global.gtc.Zombierelativ : # ADD RELATIV only if same place and destination 
				if( i4 != calling):
					if( Global.gtc.Zombierelativ.get(i4)[1] == Global.gtc.Zombierelativ.get(calling)[1]  and Global.gtc.Zombierelativ.get(i4)[2] == Global.gtc.Zombierelativ.get(calling)[2] ):
						callrelativ.append(i4)
			if(callrelativ.size() != 0):
				newtext += "with " 
				for i5 in callrelativ.size():
					newtext += get_parent().get_node("text").phonetext.relativ.get(callrelativ[i5])

			newtext += get_parent().get_node("text").phonetext.objectif.get( Global.gtc.Zombierelativ.get(calling)[3]) # ADD OBJECTIF
			get_parent()._openphonetextbox(newtext, calling) 


	if(calling == "father" ):
		if(Global.gtc.Zombieswitch.find("1stcallparents") == -1):
			Global.gtc.Zombieswitch.append("1stcallparents")

	elif(calling == "mother" ):
		if(Global.gtc.Zombieswitch.find("1stcallparents") == -1):
			Global.gtc.Zombieswitch.append("1stcallparents")
	elif(calling == "brother" ):
		if(Global.gtc.Zombieswitch.find("1stcallbrother") == -1):
			Global.gtc.Zombieswitch.append("1stcallbrother")
	elif(calling == "sister" ):
		if(ingameh < 3 or ingameh > 21):
			if(Global.gtc.Zombieswitch.find("1stcallsister") == -1):
				Global.gtc.Zombieswitch.append("1stcallsister")
		elif(ingameh == 3):
			if(Global.gtc.Zombieswitch.find("1stcallsister") == -1):
				Global.gtc.Zombieswitch.append("1stcallsister")



	_updateminimap()


func _on_B_pressed():
	if(phone == "close" or phone == "light" ):
		if(get_node("bag").visible == true):
			get_node("bag").visible = false
		else:
			get_node("bag").visible = true
	_updatehud()
	

func _popup(what):
	pass



func _on_sodabag_pressed():
	if(Global.gtc.Zombiegoods.find("soda") != -1):
		if(Global.gtc.Zombiecurrentrun < 1000):
			Global.gtc.Zombiecurrentrun += 500
			Global.gtc.Zombiegoods.erase("soda")
			get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
			get_tree().current_scene.get_node("sound").play()
		else:
			get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/error.wav"))
			get_tree().current_scene.get_node("sound").play()
		
		if(Global.gtc.Zombiecurrentrun > 1000):
			Global.gtc.Zombiecurrentrun = 1000
		get_node("hud/run/bar").scale.x = Global.gtc.Zombiecurrentrun/ Global.gtc.lifemax

	else:
		get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/error.wav"))
		get_tree().current_scene.get_node("sound").play()
		
	_updatehud()
func _on_foodbag_pressed():
	if(Global.gtc.Zombiegoods.find("food") != -1):
		if(Global.gtc.Zombiecurrentlife < 1000):
			Global.gtc.Zombiegoods.erase("food")
			Global.gtc.Zombiecurrentlife += 100
			get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
			get_tree().current_scene.get_node("sound").play()
		else:
			get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/error.wav"))
			get_tree().current_scene.get_node("sound").play()
		if(Global.gtc.Zombiecurrentlife > 1000):
			Global.gtc.Zombiecurrentlife = 1000
			
	else:
		get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/error.wav"))
		get_tree().current_scene.get_node("sound").play()
			
	_updatehud()

func _on_medbag_pressed():
	if(Global.gtc.Zombiegoods.find("medecine") != -1):
		if(Global.gtc.Zombiecurrentlife < 1000):
			Global.gtc.Zombiegoods.erase("medecine")
			Global.gtc.Zombiecurrentlife += 500
			get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/bonus1.wav"))
			get_tree().current_scene.get_node("sound").play()
		else:
			get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/error.wav"))
			get_tree().current_scene.get_node("sound").play()
		if(Global.gtc.Zombiecurrentlife > 1000):
			Global.gtc.Zombiecurrentlife = 1000
	else:
		get_tree().current_scene.get_node("sound").set_stream( preload("res://asset/sounds/error.wav"))
		get_tree().current_scene.get_node("sound").play()
	_updatehud()
