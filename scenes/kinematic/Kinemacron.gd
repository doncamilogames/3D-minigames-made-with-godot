extends KinematicBody
# Physics
var mass = 30.00


#export(float, 0.1, 3.0, 0.1) var gravity_scl = 1.0
onready var ground_ray = $GroundRay
onready var Animleg = get_node("macronwithgun/leg")
onready var Animarm = get_node("macronwithgun/arm")
onready var Animgun = get_node("macronwithgun/gun")
onready var rng = RandomNumberGenerator.new()
var move = 0
var gravity_speed = 0
var run = 0
var jump = 0
var accel = 1.0
var deaccel = 10.0
var speedtemp = 0.0
var speed = 2.0
var speedwalk = 10.0
var speedcar = 20.0
var acceleration = 2.5
var accelerationwalk  = 1.0
var accelerationcar = 0.4
var velocity = Vector3()
onready var impactobject 
onready var impactnpc
var dirshoot  = Vector3()
var dirshootpad  = Vector2()
var dirpad = Vector2()
#var life = 1000.0
var lifemax = 1000.0
var mode = "" # car, startcar
var othercol
var onwall = 0
var camheight = 10
var keyboarddir = Vector2()
var falling = 0
var chasingnpc = []
var selecteddoor # when you enter in a car 
var phone = false
var zonemode = 0
var crimevar
var delaydoor = 0
var minimap = 0
func _ready():
	crimevar = (Global.gtc.get(Global.gtc.modeselected + "currentcrime"))
#	get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat/Areabat").add_collision_exception_with(self)
	if(Global.gtc.modeselected != "Arcade"):
		get_node("phone").queue_free()
	else:
		get_node("macronwithgun/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,load("res://scenes/gta/npc/facearcade.tres"))
		var clotharray = [get_node("macronwithgun/Armature/Bone/Bone001/chest"),get_node("macronwithgun/Armature/Bone/hips"),get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("macronwithgun/Armature/Bone/Bone001/Bone003/armr"),get_node("macronwithgun/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("macronwithgun/Armature/Bone/Bone001/Bone006/arml"),get_node("macronwithgun/Armature/Bone/Bone009/ulegr"),get_node("macronwithgun/Armature/Bone/Bone009/Bone010/blegr"),get_node("macronwithgun/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("macronwithgun/Armature/Bone/Bone012/ulegl"),get_node("macronwithgun/Armature/Bone/Bone012/Bone013/blegl"),get_node("macronwithgun/Armature/Bone/Bone012/Bone013/Bone014/footl")]
		for i in clotharray :
			i.set_surface_material(0,load("res://asset/materials/clotharcade.tres"))
		if(get_parent().name == "GTATown"):
			if(Global.gtc.Arcadelastspawn != ""):
				global_transform.origin = get_tree().current_scene.find_node(Global.gtc.Arcadelastspawn).global_transform.origin
		
		
		
		
	speed = speedwalk
	rng.randomize()
	acceleration = accelerationwalk

#	Animarm.play("holdgun")
#	_showhidehud("hide")

	if(Global.gtc.get(Global.gtc.modeselected + "currentarmor") > 0):
		get_node("macronwithgun/Armature/Bone/Bone001/armor").visible = true
	if(get_parent().name != "GTATown"):
		get_parent().get_node("Camera/Camera").translation.y = camheight + (speedtemp * 1.2) 
	_updatehud()
	minimap = 0
	_on_zones_pressed()

func _showhidehud(what):
	if(what == "hide"):
		get_node("J2").visible = false
		get_node("C").visible = false
		get_node("A").visible = false
		get_node("Virtual joystick2").visible = false
		get_node("Virtual joystick").visible = false
		if(get_parent().name == "GTATown"):
			get_node("minimap").visible = false
		get_parent().get_node("hud").visible = false
	if(what == "show"):
		get_node("J2").visible = true
		get_node("C").visible = true
		get_node("A").visible = true
		get_node("Virtual joystick2").visible = true
		get_node("Virtual joystick").visible = true
		if(get_parent().name == "GTATown"):
			get_node("minimap").visible = true
		get_parent().get_node("hud").visible = true



func _updateminimap():
	
	if(get_parent().mode == "Arcade"):
		for i in get_node("minimap/Viewport/map/arcadezones").get_children():
			if(i.name != "top"):
				get_node("minimap/Viewport/map/labelzones").get_node(i.name).set_text(str(Global.gtc.Arcadeenemies.get(i.name)))
			if(i.name == get_parent().currentarea):
					if(Global.gtc.Arcadeenemies.get(i.name) <= 0):# zone cleaned
						i.self_modulate = Color( 1, 1, 1, 0.0 )
					i.self_modulate[3] = 0.3
			else:
					if(i.name != "top"):
						if(Global.gtc.Arcadeenemies.get(i.name) <= 0):# zone cleaned
							i.self_modulate = Color( 1, 1, 1, 0.0 )
						i.self_modulate[3] = 0.7


func _updatehud():
		if(Global.gtc.modeselected == "Arcade"):
			Global.gtc.Arcadecurrentcrime = crimevar
			if(Global.gtc.radioarcade == ""):
				get_node("phone/radio/newsong").visible = false
			else:
				get_node("phone/radio/newsong").visible = true
		elif(Global.gtc.modeselected == "Gstory"):
			Global.gtc.Gstorycurrentcrime = get_parent().crime
		if(get_parent().name == "GTATown"):
			_updateminimap()
			get_parent().get_node("hud/enemy").set_text("Enemies in disctrict : " + str(Global.gtc.Arcadeenemies.get(get_parent().currentarea)))
		get_parent().get_node("hud/life/bar").scale.x = Global.gtc.get(Global.gtc.modeselected + "currentlife") / lifemax
		get_parent().get_node("hud/crime/bar").scale.x = crimevar / 10.0
		get_parent().get_node("hud/life/armor").scale.x =Global.gtc.get(Global.gtc.modeselected + "currentarmor") / Global.gtc.armormax

		if(get_parent().currentweapon == "gun"):
			get_parent().get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammogun")))
		if(get_parent().currentweapon == "mgun"):
			get_parent().get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammomgun")))
		get_parent().get_node("hud/cash").set_text(str(Global.gtc.get(Global.gtc.modeselected + "cash")))


func _process(delta):
	if(global_transform.origin.y < -10):
		get_parent()._endgame()

	if(crimevar > 0.0):
		if(get_node("crimedelay").is_stopped() == true):# if you have not done bad things recently
			if(chasingnpc.size() == 0): #if no cops is chasing you
				crimevar -= 0.03
				_updatehud()
	get_parent().get_node("Camera").global_transform.origin = global_transform.origin
	dirshoot = Vector3.ZERO
	dirshoot += Vector3(get_node("Virtual joystick2")._output.normalized().x,0,get_node("Virtual joystick2")._output.normalized().y )#right stick


	if(dirshoot != Vector3.ZERO):
			_shoot(dirshoot)
			
	
	dirshootpad = Vector2(Input.get_joy_axis(0,JOY_ANALOG_RX),Input.get_joy_axis(0,JOY_ANALOG_RY) )
	if(abs(dirshootpad.x) + abs(dirshootpad.y) > 1.0):
		_shoot(Vector3(dirshootpad.x,0,dirshootpad.y))



	if(get_parent().name == "GTATown"):
		if(minimap == 3 ): #Zoomed
			get_node("minimap/Viewport/map").position.x = 100  - (global_transform.origin.x /   2.286 ) *2
			get_node("minimap/Viewport/map").position.y = 75 - ( global_transform.origin.z / 2.2839  ) *2

		elif(minimap == 1  or minimap == 0   ): #full map
			get_node("minimap/pointer").position.x = (global_transform.origin.x / 5.7165 )
			get_node("minimap/pointer").position.y = (global_transform.origin.z /8.1917)

		if(get_parent().get_node("missiontimer").get_time_left() > 0):
			get_parent().get_node("hud/timeleft").set_text("Time left : " + str(get_parent().get_node("missiontimer").get_time_left()))


		get_parent().get_node("Camera/Camera").translation.y = camheight + (speedtemp )
	if(mode == "car"):
		get_parent().closeobject.global_transform = global_transform
		get_parent().closeobject.rotation_degrees.y +=180
	if(get_parent().npcnear < get_parent().maxnpc and get_parent().justspawn == 0): 			#NPC SPAWNNNNN
		if(get_node("npc/RayCast").get_collider() != null):
			get_parent()._spawnnpc(get_node("npc/RayCast").get_collision_point())
	if(get_parent().carnear < get_parent().maxcar and get_parent().justspawncar == 0): 			#CARS SPAWNNNNN
		if(get_node("npc/RayCast2").get_collider() != null):
			get_parent()._spawncar(get_node("npc/RayCast2").get_collision_point())
	if(speedtemp > speed):
		speedtemp = speed



func _input(event):
	_axis()
#	print(Input.get_joy_axis(0, JOY_ANALOG_LX)) left stick X
#	print(Input.get_joy_axis(0, JOY_ANALOG_RY))

	
func _axis():

	keyboarddir = Vector2(0,0)
	if Input.is_action_pressed("ui_up")  == true:  # Needs to be setted on Project Settings -> InputMap
		keyboarddir -= Vector2(0,1)
	if Input.is_action_pressed("ui_down"):  # Needs to be setted on Project Settings -> InputMap
		keyboarddir += Vector2(0,1)
	if Input.is_action_pressed("ui_left"):  # Needs to be setted on Project Settings -> InputMap
		keyboarddir -= Vector2(1,0)
	if Input.is_action_pressed("ui_right"):  # Needs to be setted on Project Settings -> InputMap
		keyboarddir += Vector2(1,0)
	keyboarddir = keyboarddir.normalized()
	if Input.is_action_just_pressed("Xbutton") == true:
		_on_A_pressed()
	if Input.is_action_just_pressed("Abutton") == true:
		_on_J2_pressed()
func _physics_process(delta):
	if( mode == "" ):
		dirpad = Vector2(Input.get_joy_axis(0,JOY_ANALOG_LX),Input.get_joy_axis(0,JOY_ANALOG_LY) )
		if(abs(dirpad.x) + abs(dirpad.y) < 0.5):
			dirpad = Vector2.ZERO
		if(keyboarddir != Vector2.ZERO) : #keyboard mov
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity = Vector3(keyboarddir.x,0.0,keyboarddir.y) * speedtemp
			move = 1
			Animleg.play("Walk",-1,2.0)
		elif(get_node("Virtual joystick")._output.normalized() != Vector2.ZERO):#phone move
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity= Vector3(get_node("Virtual joystick")._output.x,0.0,get_node("Virtual joystick")._output.y)* speedtemp 
			move = 1
			Animleg.play("Walk",-1,2.0)
		elif(dirpad != Vector2.ZERO):#pad move
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity= Vector3(dirpad.x,0,dirpad.y) * speedtemp 
			move = 1
			Animleg.play("Walk",-1,2.0)
		else: #don't move
				speedtemp = lerp(speedtemp, 0.0, acceleration * delta * 2) 
				velocity = lerp(velocity,Vector3.ZERO,0.1)
				move = 0
				Animleg.play("Idle")

		if( move == 1 and dirshoot == Vector3.ZERO):
			look_at(transform.origin - velocity * 20, Vector3(0,1,0))






	elif(mode == "falling" ):
		velocity = Vector3.ZERO
		speedtemp = 0
		if(Animleg.is_playing() == false):
			falling = 0
			mode = "" 


	elif(mode == "car"):
		dirpad = Vector2(Input.get_joy_axis(0,JOY_ANALOG_LX),Input.get_joy_axis(0,JOY_ANALOG_LY) )
		if(abs(dirpad.x) + abs(dirpad.y) < 0.5):
			dirpad = Vector2.ZERO
		if(keyboarddir != Vector2.ZERO) : #keyboard mov
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity = Vector3(keyboarddir.x,0.0,keyboarddir.y) * speedtemp
			move = 1
		elif(get_node("Virtual joystick")._output.normalized() != Vector2.ZERO):#phone move
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity= Vector3(get_node("Virtual joystick")._output.x,0.0,get_node("Virtual joystick")._output.y)* speedtemp 
			move = 1
		elif(dirpad != Vector2.ZERO):#pad move
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity= Vector3(dirpad.x,0,dirpad.y) * speedtemp 
			move = 1

		else: #don't move
				speedtemp = lerp(speedtemp, 0.0, acceleration * delta * 2) 
				velocity = lerp(velocity,Vector3.ZERO,0.1)
				move = 0

		if(is_on_wall()):
			if(onwall == 0):
				if(speedtemp > 8.0):
					get_parent().closeobject._damagecar(speedtemp)
			onwall = 1
			speedtemp = lerp(speedtemp, 0.0, acceleration * delta * 10) 
		else:
			onwall = 0
		if(get_parent().closeobject.broke == 1):
			speedtemp = 0.0
			velocity = Vector3.ZERO
		else:
			if( move == 1 ):
				look_at(transform.origin - velocity * 20, Vector3(0,1,0))



	elif(mode == "startcar"):
		if(get_parent().closeobject.get_node("Animexplode").is_playing() == true):
			rotation_degrees.y =( get_parent().closeobject.rotation_degrees.y + 180 )
			if(selecteddoor == 1):
				global_transform.origin = get_parent().closeobject.get_node("door1pos").global_transform.origin
			if(selecteddoor == 2):
				global_transform.origin = get_parent().closeobject.get_node("door2pos").global_transform.origin
				get_node("macronwithgun").scale.x = -0.2
		else:
			mode = "car"
			get_parent().closeobject.get_node("Animexplode").play("resetpos")
			get_node("macronwithgun").scale.x = 0.2
			get_node("macronwithgun").visible = false
			if(Global.gtc.modeselected != "Arcade"):
				get_parent().get_node("music").play()
	elif(mode == "stopcar"):
		if(get_parent().closeobject.get_node("Animexplode").is_playing() == true):
			rotation_degrees.y =( get_parent().closeobject.rotation_degrees.y + 180 )
			global_transform.origin = get_parent().closeobject.get_node("door1pos").global_transform.origin
			
		else:
			get_parent().closeobject.remove_collision_exception_with(self)
			mode = ""
			get_parent().closeobject.get_node("Animexplode").play("resetpos")

	elif(mode == "dead"):
		velocity = Vector3.ZERO
		
		get_parent().get_node("Camera/Camera").translation.y -=0.03
		get_parent().get_node("Camera/Camera").rotation_degrees.y += 2
		get_parent().get_node("Camera").global_transform.origin = global_transform.origin
		if(get_parent().get_node("Camera/Camera").translation.y <= 0.0):
			get_tree().change_scene("res://scenes/gta/gtamenu.tscn")

	if(!ground_ray.is_colliding() ):# NOT ON GROUND
		gravity_speed -=  mass * delta
		velocity.y = gravity_speed

	gravity_speed = move_and_slide(velocity, Vector3(0,1,0), false).y

func _shooted(who,strength):
	if( mode != "dead"):
		if(mode != "car" and mode != "startcar" and mode != "stopcar" ):
			get_parent().get_node("hud/touched/AnimationPlayer").play("Anim")
			look_at(who.global_transform.origin,Vector3(0,1,0))
			rotation_degrees.y -= 180
			_receivedamage(strength,"weapon")
		else:
			get_parent().closeobject._shooted(who,strength)


func _cared(amount):
	if( mode != "dead"):
		if(mode != "car" and mode != "startcar" and mode != "stopcar" ):
			_receivedamage(amount,"car")
		else:
			get_parent().closeobject._cared(amount)

func _receivedamage(amount,type):
		get_parent().get_node("hud/touched/AnimationPlayer").play("Anim")
		if(rng.randi_range(1,100) < amount or type == "car"): #fall depend on the weapon strength, always with car
			Animleg.play("fall")
			mode = "falling"
			falling = 1

		if(Global.gtc.get(Global.gtc.modeselected + "currentarmor") > 0 ): #if armor
			if(amount > Global.gtc.get(Global.gtc.modeselected + "currentarmor")): # armor destroyed
				amount -= Global.gtc.get(Global.gtc.modeselected + "currentarmor")
				if(Global.gtc.modeselected == "Arcade"):
					Global.gtc.Arcadecurrentarmor = 0
				elif(Global.gtc.modeselected == "Gstory"):
					Global.gtc.Gstorycurrentarmor = 0
				get_node("macronwithgun/Armature/Bone/Bone001/armor").visible = false
			else: # armor damaged, receive no damage 
				if(Global.gtc.modeselected == "Arcade"):
					Global.gtc.Arcadecurrentarmor -= amount
				elif(Global.gtc.modeselected == "Gstory"):
					Global.gtc.Gstorycurrentarmor -= amount
				amount = 0

		if(Global.gtc.modeselected == "Arcade"):
				Global.gtc.Arcadecurrentlife -= amount
		elif(Global.gtc.modeselected == "Gstory"):
				Global.gtc.Gstorycurrentlife -= amount
		get_parent().get_node("hud/touched/AnimationPlayer").play("Anim")
		if(Global.gtc.get(Global.gtc.modeselected + "currentlife") <= 0):
			get_parent()._endgame()
		_updatehud()


func _on_J2_pressed():#inventory
	if( mode != "dead"):
		if( mode != "car" ):
			var temp = get_parent().inventory.find(get_parent().currentweapon)
			if(temp+1  < get_parent().inventory.size()  ):
				get_parent().currentweapon = get_parent().inventory[temp+1]
			else:
				get_parent().currentweapon = get_parent().inventory[0]
			_changegun()

func _changegun():
		get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = false
		get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = false
		get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/mgun").visible = false
		get_parent().get_node("hud/weapon/ammo").visible = false
		if(Global.gtc.modeselected == "Arcade"):
			Global.gtc.Arcadecurrentweapon = get_parent().currentweapon
		if(Global.gtc.modeselected == "Gstory"):
			Global.gtc.Gstorycurrentweapon = get_parent().Gstorycurrentweapon

		if(get_parent().currentweapon == "nothing"):
			get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
			get_node("weaponsound").pitch_scale = 2.0
			get_parent().get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/hand1.png")
		elif(get_parent().currentweapon == "bat"):
			get_node("weaponsound").pitch_scale = 1.0
			get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
			get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = true
			get_parent().get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/bat.png")
		elif(get_parent().currentweapon == "gun"):
			get_node("weaponsound").pitch_scale = 0.8
			get_node("weaponsound").set_stream( preload("res://asset/sounds/tac1.wav"))
			get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = true
			get_parent().get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/gun.png")
			get_parent().get_node("hud/weapon/ammo").visible = true
			get_parent().get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammogun")))
		elif(get_parent().currentweapon == "mgun"):
			get_node("weaponsound").pitch_scale = 1.2
			get_node("weaponsound").set_stream( preload("res://asset/sounds/tac1.wav"))
			get_node("macronwithgun/Armature/Bone/Bone001/Bone003/Bone004/Bone005/mgun").visible = true
			get_parent().get_node("hud/weapon/icon").texture = preload("res://asset/textures/gta/mgun.png")
			get_parent().get_node("hud/weapon/ammo").visible = true
			get_parent().get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammomgun")))

func _shoot(where):
	if(mode == ""):
		look_at(transform.origin - where *  200, Vector3(0,1,0))

		if(get_parent().currentweapon == "gun" and Global.gtc.get(Global.gtc.modeselected + "ammogun") > 0):
			if(Animgun.is_playing() == false):
				if(Global.gtc.modeselected == "Arcade"):
					Global.gtc.Arcadeammogun -=1
				if(Global.gtc.modeselected == "Gstory"):
					Global.gtc.Gstoryammogun -=1
				get_parent().get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammogun")))
				Animarm.play("holdgun")
				Animgun.play("shoot")
				get_node("weaponsound").play()
				if(get_node("guncast").is_colliding()):
					if(get_node("guncast").get_collider().has_method("_shooted")):
						get_node("guncast").get_collider()._shooted(self, get_parent().weaponstrength.get(get_parent().currentweapon))
						if(get_node("guncast").get_collider().has_method("_npc")):
									_crime(1.0)
						if(get_node("guncast").get_collider().is_in_group("cops")):
									_crime(2.0)
						elif(get_node("guncast").get_collider().is_in_group("ennemy")):
									_crime(0.3)
					if(get_node("guncast").get_collider().is_in_group("breakable")):
						get_node("guncast").get_collider().queue_free()
					impactobject = preload("res://scenes/kinematic/impactobject.tscn").instance()
					get_parent().add_child(impactobject)
					impactobject.global_transform.origin = get_node("guncast").get_collision_point()
					impactobject.scale = Vector3(0.1,0.1,0.1)

		if(get_parent().currentweapon == "mgun" and Global.gtc.get(Global.gtc.modeselected + "ammomgun") > 0):
			if(Animgun.is_playing() == false):
				if(Global.gtc.modeselected == "Arcade"):
					Global.gtc.Arcadeammomgun -=1
				if(Global.gtc.modeselected == "Gstory"):
					Global.gtc.Gstoryammomgun -=1
				get_parent().get_node("hud/weapon/ammo").set_text(str(Global.gtc.get(Global.gtc.modeselected + "ammomgun")))
				Animarm.play("holdgun")
				Animgun.play("mshoot",-1,3.0)
				get_node("weaponsound").play()
				if(get_node("guncast").is_colliding()):
					if(get_node("guncast").get_collider().has_method("_shooted")):
						get_node("guncast").get_collider()._shooted(self, get_parent().weaponstrength.get(get_parent().currentweapon))
						if(get_node("guncast").get_collider().has_method("_npc")):
									_crime(1.0)
						if(get_node("guncast").get_collider().is_in_group("cops")):
									_crime(2.0)
						elif(get_node("guncast").get_collider().is_in_group("ennemy")):
									_crime(0.3)
					if(get_node("guncast").get_collider().is_in_group("breakable")):
						get_node("guncast").get_collider().queue_free()
					impactobject = preload("res://scenes/kinematic/impactobject.tscn").instance()
					get_parent().add_child(impactobject)
					impactobject.global_transform.origin = get_node("guncast").get_collision_point()
					impactobject.scale = Vector3(0.1,0.1,0.1)


		if(get_parent().currentweapon == "nothing"):
			if(Animarm.is_playing() == false):
				Animarm.play("punch",-1,1.8)
				look_at(transform.origin - where *  200, Vector3(0,1,0))

		if(get_parent().currentweapon == "bat"):
			if(Animarm.is_playing() == false):
				Animarm.play("sword",-1,1.5)
				look_at(transform.origin - where *  200, Vector3(0,1,0))



func _on_Areapunch_body_entered(body):
	if(Animarm.current_animation == "punch"):
		if(body.has_method("_shooted") and body != self):
			get_node("weaponsound").play()
			body._shooted(self, get_parent().weaponstrength.get(get_parent().currentweapon))
			if(body.has_method("_npc")):
						_crime(0.3)
			if(body.is_in_group("cops")):
						_crime(0.6)
			elif(body.is_in_group("ennemy")):
						_crime(0.1)
		if(body.is_in_group("breakable")):
			body.queue_free()

func _on_Areabat_body_entered(body):
	if(Animarm.current_animation == "sword"):
		if(body.has_method("_shooted") and body != self):
			get_node("weaponsound").play()
			body._shooted(self, get_parent().weaponstrength.get(get_parent().currentweapon))
			if(body.has_method("_npc")):
						_crime(0.7)
			if(body.is_in_group("cops")):
						_crime(1.3)
			elif(body.is_in_group("ennemy")):
						_crime(0.3)
		if(body.is_in_group("breakable")):
			body.queue_free()
#		if(body.is_in_group("breakable")):




func _crime(amount):
	crimevar += (amount / 2)
	crimevar = clamp(crimevar,0.0,10.0 )
	
	if(Global.gtc.modeselected == "Arcade"):
		Global.gtc.Arcadecurrentcrime = crimevar

	if(Global.gtc.modeselected == "Gstory"):
		Global.gtc.Gstorycurrentcrime = get_parent().crime
	_updatehud()
	get_node("crimedelay").stop()
	get_node("crimedelay").start()


func _on_crimedelay_timeout():
	pass


func _on_A_pressed():
	if(mode == "car"):
		if(Global.gtc.modeselected == "Arcade"):
			mode = "stopcar"
			Animleg.play_backwards("Incar")
			get_parent().closeobject.get_node("Animexplode").play_backwards("opendoor1")

			get_parent().closeobject._owner = null
			get_node("Collcar").set_shape(null)
			acceleration = accelerationwalk
			speed = speedwalk
			get_node("macronwithgun").visible = true
			#get_parent().get_node("music").stop()
			return
		if("story" in Global.gtc.modeselected ):
			if("onlycar" in get_parent().currentmission.get("restrictions")):
				pass #message to say you can t
			else: #exit car
				mode = "stopcar"
				Animleg.play_backwards("Incar")
				get_parent().closeobject.get_node("Animexplode").play_backwards("opendoor1")
				get_parent().closeobject.remove_collision_exception_with(self)
				get_parent().closeobject._owner = null
				get_node("Collcar").set_shape(null)
				acceleration = accelerationwalk
				speed = speedwalk
				get_node("macronwithgun").visible = true
				get_parent().get_node("music").stop()
				return

	if(get_parent().closeobject != null  and mode != "car" and falling == 0 and mode != "startcar" and  mode != "stopcar"):
		if(get_parent().closeobject.has_method("_car")):#enter car
			if(get_parent().closeobject.broke == 0):
				if(get_parent().closeobject.nearchest == 0):
					var door1 = global_transform.origin.distance_to(get_parent().closeobject.get_node("door1pos").global_transform.origin)
					var door2 = global_transform.origin.distance_to(get_parent().closeobject.get_node("door2pos").global_transform.origin)
					if(door1 < door2):
						get_parent().closeobject.get_node("Animexplode").play("opendoor1")
						selecteddoor = 1
					else:
						selecteddoor = 2
						get_parent().closeobject.get_node("Animexplode").play("opendoor2")
					Animleg.play("Incar")
					get_node("A/icon").texture = preload("res://asset/textures/gta/car1.png")
					global_transform.origin = get_parent().closeobject.global_transform.origin
					mode = "startcar"
					get_parent().closeobject.add_collision_exception_with(self)
					var shapee = get_parent().closeobject.get_node("CollisionShapecar").get_shape()
					get_node("Collcar").set_shape(shapee)
		#			_reparent(get_parent().closeobject.get_node("CollisionShapecar"),self)
					get_parent().closeobject._owner = "player"
					acceleration = accelerationcar
					speed = speedcar
				else:
					get_parent().closeobject.get_node("Animexplode").play("openchest")

		if(get_parent().closeobject.has_method("_door") and delaydoor == 1 ):
				if("shop" in get_parent().name ):
					pass
				else:
					Global.gtc.spawnpoint = get_parent().closeobject._spawn
				if("shop" in get_parent().closeobject.get_parent().name ):
					Global.gtc.spawnpointtown = get_parent().closeobject.get_parent().name
					if(Global.gtc.modeselected == "Arcade"):
						Global.gtc.Arcadelastspawn = get_parent().closeobject.get_parent().name
						
				get_tree().change_scene(get_parent().closeobject._scene)
		if(get_parent().closeobject.has_method("_intdoor")):
				get_parent().closeobject._open()

		if(get_parent().closeobject.has_method("_shop")):
				get_parent().closeobject._shop()


func _on_b_button_down():
	if(get_parent().started == 0):
		get_parent()._endcutscene()
		
		return
	if(get_parent().started == 1):
		get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Area_body_entered(body):
	pass # Replace with function body.


func _reparent(child : Node, new_parent : Node):
	var oldp = child.get_parent()
	oldp.remove_child(child)
	new_parent.add_child(child)


func _on_C_pressed():
	if(camheight == 10):
		camheight = 60
		return
	if(camheight == 60):
		camheight = 10
		return




func _on_phone_pressed():
	if(phone == false):
		get_node("phone/AnimationPlayer").play("phone")
		phone = true
	else:
		get_node("phone/AnimationPlayer").play_backwards("phone")
		phone = false

func _radio():

	if(Global.gtc.radioarcade == ""):
		get_parent().get_node("music").stop()
		var songs = rng.randi_range(0,Global.gtcradio.size() -1 )
		var songplayed = Global.gtcradio.keys()[songs]
		songplayed = load(Global.gtcradio.get(songplayed))
		get_parent().get_node("music").set_stream(songplayed) 
		get_parent().get_node("music").play()
		Global.gtc.radioarcade = Global.gtcradio.keys()[songs]
		get_node("phone/radio/current").set_text(Global.gtc.radioarcade)
		get_node("phone/radio").set_text("Radio On")
	else: 
		get_parent().get_node("music").stop()
		Global.gtc.radioarcade = ""
		get_node("phone/radio/current").set_text("")
		get_node("phone/radio").set_text("Radio Off")
	_updatehud()
#	print(Global.gtc.radioarcade)
func _on_radio_pressed():
	_radio()


func _on_newsong_pressed():
	if(Global.gtc.radioarcade == ""):
		pass
	else:

		var tempsong = Global.gtcradio.values().find(Global.gtcradio.get(Global.gtc.radioarcade)) + 1
		if(tempsong > Global.gtcradio.size()-1):
			tempsong = 0
			get_parent().get_node("music").stop()
			var songplayed = Global.gtcradio.keys()[tempsong]
			songplayed = load(Global.gtcradio.get(songplayed))
			get_parent().get_node("music").set_stream(songplayed) 
			get_parent().get_node("music").play()
			Global.gtc.radioarcade = Global.gtcradio.keys()[tempsong]
			
		else:
			get_parent().get_node("music").stop()
			var songplayed = Global.gtcradio.keys()[tempsong]
			songplayed = load(Global.gtcradio.get(songplayed))
			get_parent().get_node("music").set_stream(songplayed) 
			get_parent().get_node("music").play()
			Global.gtc.radioarcade = Global.gtcradio.keys()[tempsong]
		get_node("phone/radio/current").set_text(Global.gtc.radioarcade)
		_updatehud()
#	print(Global.gtcradio.values().find(Global.gtcradio.get(Global.gtc.radioarcade)))
#	print(Global.gtc.radioarcade)

func _on_zones_pressed():
	
	if(minimap == 0):
			minimap = 1
			get_node("minimap").rect_scale = Vector2(1,1)
			get_node("minimap").rect_position = Vector2(630,445)
			get_node("minimap/Viewport/map").scale = Vector2(0.4,0.279)
			get_node("minimap/Viewport/map").position =  Vector2(0,0)
			get_node("minimap/Viewport/map/icons").set_modulate("ffffffff")
			for i in get_node("minimap/Viewport/map/icons").get_children():
				i.scale = Vector2(1,1)

			
			
	elif(minimap == 1):
			minimap = 2
			get_node("minimap").visible = false

	elif(minimap == 2):
			minimap = 3
			get_node("minimap").visible = true
			get_node("minimap/Viewport/map").scale = Vector2(2,2)
#			get_node("minimap").rect_position = Vector2(630,440)
			get_node("minimap/pointer").position = Vector2(100,75)
			get_node("minimap/Viewport/map/icons").set_modulate("ffffffff")
			for i in get_node("minimap/Viewport/map/icons").get_children():
				i.scale = Vector2(0.5,0.5)

			
	elif(minimap == 3):
			minimap = 0
			get_node("minimap").rect_scale = Vector2(2,2)
			get_node("minimap").rect_position = Vector2(600,290)
			get_node("minimap/Viewport/map").scale = Vector2(0.4,0.279)
			get_node("minimap/Viewport/map").position =  Vector2(0,0)
			get_node("minimap/Viewport/map/icons").set_modulate("ffffffff")
			for i in get_node("minimap/Viewport/map/icons").get_children():
				i.scale = Vector2(1,1)

	

		
		

func _on_zones2_pressed():
	Global._savegame()


func _on_delaydoor_timeout():
	delaydoor = 1




func _on_mapinfo_pressed():
	if(zonemode == 0):#zone without nb
		get_node("minimap/Viewport/map/arcadezones").visible = true
		get_node("minimap/Viewport/map/labelzones").visible = true
		zonemode = 1
		return
	if(zonemode == 1):# no zone
		get_node("minimap/Viewport/map/arcadezones").visible = false
		get_node("minimap/Viewport/map/labelzones").visible = false
		zonemode = 2
		return
	if(zonemode == 2):#zone with nb
		get_node("minimap/Viewport/map/arcadezones").visible = true
		get_node("minimap/Viewport/map/labelzones").visible = false
		zonemode = 0
		return
		
