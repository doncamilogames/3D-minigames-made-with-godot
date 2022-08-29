extends KinematicBody
const GRAVITY = 9.8
var jump_height = 15.0
var mass = 30.00
onready var ground_ray = $GroundRay
onready var Animleg = get_node("mesh/leg")
onready var Animarm = get_node("mesh/arm")
onready var Animgun = get_node("mesh/gun")
onready var impactobject 
var gravity_speed = 0
var jump = 0
var speedtemp = 0.0
var speed = 10.0
var speedturn = 2.0
var acceleration = 0.8
var forward_speed = 0.0
var side_speed = 0.0
var velocity = Vector3()
var move  = 0
var life = 4.0
var lifemax = 10.0
var closeobject
var mode = "" # "", warp, bag, freezed, cutscene, dead, 
var targetlist = []
var targetsuggest = 0
var targetchoice
var currentwater #when swim, for direction
var fixedpos = Vector3.ZERO
var hooktarget = Vector3.ZERO
var railcut
export var humskel = ""
onready var humanmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/head"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handr"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handl"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/hips")]
onready var skelmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/headskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlskel"),get_node("mesh/Armature/Bone/Bone001/chestskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrskel"),get_node("mesh/Armature/Bone/Bone009/ulegrskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglskel"),get_node("mesh/Armature/Bone/Bone012/uleglskel"),get_node("mesh/Armature/Bone/hipsskel")]
onready var arrow = preload("res://scenes/monsteroftime/arrow.tscn")
var currentweapon = "sword"
var jloutput = Vector2.ZERO
var jroutput = Vector2.ZERO
var _axisresult = Vector3.ZERO
var lpadstick =   Vector2.ZERO
var rpadstick =  Vector2.ZERO


func _ready():
	
	currentweapon = Global.mot.currentweapon
	get_node("guncast").add_exception(get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield"))
	get_node("guncast").add_exception(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword"))
	get_node("guncast").add_exception(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade"))
	add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade"))
#	add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword"))
	add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield"))
#	get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword"))

	get_node("Spring/SpringArm").add_excluded_object(self.get_rid())
	if(humskel == ""):		#if human or skeleton, delete the unused meshes 
			for i in skelmeshes:
				i.queue_free()
	if(humskel == "skel"):
			for i in humanmeshes:
				i.queue_free()
	_updatehud()

func _process(delta):
	jloutput =  get_node("hud/Virtual joystick")._output
	jroutput =  get_node("hud/Virtual joystick2")._output
	lpadstick  = Vector2(Input.get_joy_axis(0,JOY_ANALOG_LX),Input.get_joy_axis(0,JOY_ANALOG_LY) )
	rpadstick =  Vector2(Input.get_joy_axis(0,JOY_ANALOG_RX),Input.get_joy_axis(0,JOY_ANALOG_RY) )
	if(abs(lpadstick.x) + abs(lpadstick.y) < 0.5):
			lpadstick = Vector2.ZERO
	if(abs(rpadstick.x) + abs(rpadstick.y) < 0.3):
			rpadstick = Vector2.ZERO
	
	_axisresult = _axis()

	if(get_node("guncast").get_collider() != null):
		get_node("hud/targetbow").position = get_node("Spring/SpringArm/Camera").unproject_position(get_node("guncast").get_collision_point()) #2d sprite
		get_node("hud/targetbow").self_modulate = "ffffff"
	else:
		get_node("hud/targetbow").self_modulate = "8077747d"
	if(speedtemp > speed):
		speedtemp = speed
	if(targetchoice != null):
		get_node("Spring").look_at(targetchoice.get_node("targetpos").global_transform.origin,Vector3.UP)
		get_node("hud/targetp").position = get_node("Spring/SpringArm/Camera").unproject_position(targetchoice.get_node("targetpos").global_transform.origin) #2d sprite
		get_node("hud/targetbow").position = get_node("hud/targetp").position
		if(global_transform.origin.distance_to(targetchoice.global_transform.origin) > 15 ):
			targetchoice = null
	else:
		get_node("Spring").rotation_degrees = lerp(get_node("Spring").rotation_degrees, Vector3.ZERO, 0.1)
		get_node("hud/targetp").position = Vector2(1000,1000)

func _input(event):
	if Input.is_action_just_pressed("Abutton") == true:
		_on_A_pressed()
	elif Input.is_action_just_pressed("Xbutton") == true:
		_on_J2_pressed()
	elif Input.is_action_just_pressed("Ybutton") == true:
		_on_C_pressed()
	elif Input.is_action_just_pressed("Bbutton") == true:
		_on_B_pressed()
	elif Input.is_action_just_pressed("rb") == true:
		_on_A_pressed()
	elif Input.is_action_just_pressed("lb") == true:
		_changeweapon()
		
		
func _changeweapon():

	
	var temp = Global.mot.inventory.find(Global.mot.currentweapon)

	if(temp+1  < Global.mot.inventory.size()  ):
		Global.mot.currentweapon = Global.mot.inventory[temp+1]

	else:
		Global.mot.currentweapon =  Global.mot.inventory[0]

	currentweapon = Global.mot.currentweapon 
	_updatehud()

func _axis():
	var direction = Vector3()
	if Input.is_action_pressed("ui_up")  == true:  # Needs to be setted on Project Settings -> InputMap
		direction -= Vector3(0,0,1) #go foward
	if Input.is_action_pressed("ui_down"):  # Needs to be setted on Project Settings -> InputMap
		direction += Vector3(0,0,1)
	if Input.is_action_pressed("ui_left"):  # Needs to be setted on Project Settings -> InputMap
		direction -= Vector3(1,0,0)
	if Input.is_action_pressed("ui_right"):  # Needs to be setted on Project Settings -> InputMap
		direction += Vector3(1,0,0)
	if(direction == Vector3(0,0,0)):
		move = 0
	else :
		move = 1

	return direction.normalized()

func _physics_process(delta):
	if(mode == ""):
		if(jroutput.normalized() != Vector2.ZERO) : #  CAMERA
			get_node("Spring/SpringArm").rotation_degrees.y = lerp(get_node("Spring/SpringArm").rotation_degrees.y, 90 * jroutput.x,delta )
			get_node("Spring/SpringArm").rotation_degrees.x = lerp(get_node("Spring/SpringArm").rotation_degrees.x, 45 * jroutput.y,delta )
			get_node("guncast").rotation_degrees.y = lerp(get_node("guncast").rotation_degrees.y, 90 * jroutput.x,delta ) #2d sprite
			get_node("guncast").rotation_degrees.x = lerp(get_node("guncast").rotation_degrees.x, 45 * jroutput.y,delta ) #2d sprite
			get_node("hud/A").position = Vector2(64,305)

			
		elif(rpadstick != Vector2.ZERO) : #  CAMERA stick
			get_node("Spring/SpringArm").rotation_degrees.y = lerp(get_node("Spring/SpringArm").rotation_degrees.y, 90 * rpadstick.x,delta )
			get_node("Spring/SpringArm").rotation_degrees.x = lerp(get_node("Spring/SpringArm").rotation_degrees.x, 45 * rpadstick.y,delta )
			get_node("guncast").rotation_degrees.y = lerp(get_node("guncast").rotation_degrees.y, 90 * rpadstick.x,delta ) #2d sprite
			get_node("guncast").rotation_degrees.x = lerp(get_node("guncast").rotation_degrees.x, 45 * rpadstick.y,delta ) #2d sprite
			get_node("hud/A").position = Vector2(64,305)

			
			
			
		else:
			get_node("Spring/SpringArm").rotation_degrees = lerp(get_node("Spring/SpringArm").rotation_degrees,Vector3(-10,-01,0),delta * 3)
			get_node("guncast").rotation_degrees =  Vector3.ZERO #2d sprite
			get_node("hud/A").position = Vector2(897,313)
			
			
		if(jloutput.normalized() != Vector2.ZERO) :   #   PHONE MOVMENTS  
			if(targetchoice == null):
				if(abs(jloutput.normalized().x) > 0.25):
					rotation_degrees.y = rotation_degrees.y - jloutput.x  * speedturn
					
			else : 
				if(abs(jloutput.normalized().x) > 0.25):
					side_speed = jloutput.x * speedtemp
				else:
					side_speed = 0
				look_at(targetchoice.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			if(jloutput.y < -0.5): #forward
				forward_speed = jloutput.y * speedtemp
				Animleg.play("run2",-1,1)
			else: #backward
				if(currentweapon == "sword"):
					forward_speed =( jloutput.y * speedtemp) / 20
					Animarm.play("shield")
				if(currentweapon == "bow"  or currentweapon == "hook"):
					forward_speed =( jloutput.y * speedtemp) / 2
				Animleg.play("Walk",-1,2.0)
			rotation_degrees.x = 0
			rotation_degrees.z = 0

			velocity = transform.basis.z * forward_speed# Movement is always forward
			if(targetchoice != null):
				velocity += transform.basis.x * side_speed

			
		elif(_axisresult != Vector3.ZERO) :    #   KEYBOARD  MOVMENTS  
			if(targetchoice == null):
				rotation_degrees.y = rotation_degrees.y - _axisresult.x  * speedturn

			else : 
				side_speed = _axisresult.x * speedtemp
				look_at(targetchoice.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			
			if(_axisresult.z <= 0.0):
				forward_speed = _axisresult.z * speedtemp
				if(_axisresult.x == 0.0):
					Animleg.play("run2",-1,1)
				else:
					Animleg.play("Walk",-1,2.0)
			else: #backward
				Animleg.play("Walk",-1,2.0)
				if(currentweapon == "sword"):
					forward_speed =( _axisresult.z * speedtemp) / 20
					Animarm.play("shield")
				if(currentweapon == "bow" or currentweapon == "hook"):
					forward_speed =( _axisresult.z * speedtemp ) / 2
			velocity = transform.basis.z * forward_speed

			if(targetchoice != null):
				velocity += transform.basis.x * side_speed
				


		elif(lpadstick != Vector2.ZERO) :   #   pad MOVMENTS  
			if(targetchoice == null):
				if(abs(lpadstick.x) > 0.25):
					rotation_degrees.y = rotation_degrees.y - lpadstick.x  * speedturn
			else : 
				if(abs(lpadstick.x) > 0.25):
					side_speed = lpadstick.x * speedtemp
				else:
					side_speed = 0
				look_at(targetchoice.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			if(lpadstick.y < 0.5): #forward
				forward_speed = lpadstick.y * speedtemp
				Animleg.play("run2",-1,1)
			else: #backward
				if(currentweapon == "sword"):
					forward_speed =( lpadstick.y * speedtemp) / 20
					Animarm.play("shield")
				if(currentweapon == "bow"  or currentweapon == "hook"):
					forward_speed =( lpadstick.y * speedtemp) / 2
				Animleg.play("Walk",-1,2.0)
			rotation_degrees.x = 0
			rotation_degrees.z = 0

			velocity = transform.basis.z * forward_speed# Movement is always forward
			if(targetchoice != null):
				velocity += transform.basis.x * side_speed



		else: #don't move
			speedtemp = lerp(speedtemp, 0, acceleration * delta * 5)
			velocity = lerp(velocity,Vector3.ZERO,0.2)
			Animleg.play("Idleanimated")
		gravity_speed -=  mass * delta # Gravity
		velocity.y = gravity_speed

		if(jump == 1): #jump
			rotation_degrees.x = 0
			rotation_degrees.z = 0
			_playsound("jump")
			velocity.y += jump_height
			jump = 0 

		gravity_speed = move_and_slide(velocity, Vector3(0,1,0), true,2,0.785398,false).y

		if(get_slide_count() > 0): #stop is slope is too hard
			if(get_slide_collision(0).get_angle() > 0.8 and get_slide_collision(0).get_angle() < 1.57079):
				velocity = Vector3(0,-5,0)
				gravity_speed = move_and_slide(velocity, Vector3(0,1,0), false).y
	elif(mode == "warping"):
		velocity = transform.basis.z * -speed
		velocity.y = gravity_speed
		gravity_speed = move_and_slide(velocity, Vector3(0,1,0), false).y
		get_node("Spring/SpringArm/Camera").global_transform.origin = fixedpos
		if(get_parent().get_node("pos/Animtransition").is_playing() == false):
			get_tree().change_scene(Global.mot.changescene)
	elif(mode == "dooring"):
		if(get_parent().get_node("pos/Animtransition").is_playing() == false):
			get_tree().change_scene(Global.mot.changescene)
	elif(mode == "changingroom"):
		Animleg.play("Walk")

	elif(mode == "falling"):
		velocity.x = lerp(velocity.x,0.0,0.1)
		velocity.z = lerp(velocity.z,0.0,0.1 )
		gravity_speed -=  mass * delta # Gravity
		velocity.y = gravity_speed
		gravity_speed = move_and_slide(velocity, Vector3(0,1,0), true,2,0.785398,false).y

		if(Animleg.get_current_animation() != "fall"):
			mode = ""
			_updatehud()
	elif(mode == "hooking"):
		Animleg.play("Idle")
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").global_transform.origin = get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/chain/Position3D").global_transform.origin
		_playsound("hook")
		if(Animgun.get_current_animation() != "hook"):
			get_node("mesh/gun").play_backwards("hook")
			mode = ""
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade/CollisionShape").disabled = true
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").rotation_degrees = Vector3(0,-180,0)
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").transform.origin = Vector3(0,0,-2.514)
	elif(mode == "hooked"):
		velocity = (hooktarget - global_transform.origin).normalized() * 30
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").global_transform.origin = get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/chain/Position3D").global_transform.origin
		gravity_speed = move_and_slide(velocity, Vector3(0,1,0), true,2,0.785398,false).y
		get_node("mesh/gun").play_backwards("hook")
		_playsound("hook")
		if(is_on_wall() or is_on_ceiling()):
			mode = ""
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade/CollisionShape").disabled = true
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").transform.origin = Vector3(0,0,-2.514)
	#		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").rotation_degrees = Vector3(0,-180,0)
			gravity_speed = move_and_slide(velocity, Vector3(0,1,0), false).y


		if(hooktarget.distance_to(global_transform.origin) < 1):
			velocity = Vector3.ZERO
			mode = ""
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade/CollisionShape").disabled = true
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").transform.origin = Vector3(0,0,-2.514)
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").rotation_degrees = Vector3(0,-180,0)
			gravity_speed = move_and_slide(velocity, Vector3(0,1,0), false).y

	elif(mode == "talking"):
		pass

	elif(mode == "swim"):
		
		if(jroutput.normalized() != Vector2.ZERO) : #  CAMERA
			get_node("Spring/SpringArm").rotation_degrees.y = lerp(get_node("Spring/SpringArm").rotation_degrees.y, 90 * jroutput.x,delta )
			get_node("Spring/SpringArm").rotation_degrees.x = lerp(get_node("Spring/SpringArm").rotation_degrees.x, 45 * jroutput.y,delta )
			get_node("guncast").rotation_degrees.y = lerp(get_node("guncast").rotation_degrees.y, 90 * jroutput.x,delta ) #2d sprite
			get_node("guncast").rotation_degrees.x = lerp(get_node("guncast").rotation_degrees.x, 45 * jroutput.y,delta ) #2d sprite
			get_node("hud/A").position = Vector2(64,305)

			
		elif(rpadstick != Vector2.ZERO) : #  CAMERA stick
			get_node("Spring/SpringArm").rotation_degrees.y = lerp(get_node("Spring/SpringArm").rotation_degrees.y, 90 * rpadstick.x,delta )
			get_node("Spring/SpringArm").rotation_degrees.x = lerp(get_node("Spring/SpringArm").rotation_degrees.x, 45 * rpadstick.y,delta )
			get_node("guncast").rotation_degrees.y = lerp(get_node("guncast").rotation_degrees.y, 90 * rpadstick.x,delta ) #2d sprite
			get_node("guncast").rotation_degrees.x = lerp(get_node("guncast").rotation_degrees.x, 45 * rpadstick.y,delta ) #2d sprite
			get_node("hud/A").position = Vector2(64,305)

			
			
			
		if(jloutput.normalized() != Vector2.ZERO) :   #   PHONE MOVMENTS  
			if(targetchoice == null):
				if(abs(jloutput.normalized().x) > 0.25):
					rotation_degrees.y = rotation_degrees.y - jloutput.x  * speedturn
			else : 
				if(abs(jloutput.normalized().x) > 0.25):
					side_speed = jloutput.x * speedtemp
				else:
					side_speed = 0
				look_at(targetchoice.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
			speedtemp = lerp(speedtemp, speed * 0.8, acceleration *0.8* delta)
			if(jloutput.normalized().y < -0.5): #forward
				forward_speed = jloutput.y * speedtemp
				Animleg.play("swimmove")
			else: #backward
				forward_speed =( jloutput.y * speedtemp) / 2
				Animleg.play("swimidle",-1,2.0)
			rotation_degrees.x = 0
			rotation_degrees.z = 0

			velocity = transform.basis.z * forward_speed# Movement is always forward
			if(targetchoice != null):
				velocity += transform.basis.x * side_speed

		elif(_axisresult != Vector3.ZERO) :    #   KEYBOARD  MOVMENTS  
			if(targetchoice == null):
				rotation_degrees.y = rotation_degrees.y - _axisresult.x  * speedturn
			else : 
				side_speed = _axisresult.x * speedtemp
				look_at(targetchoice.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
			speedtemp = lerp(speedtemp, speed * 0.8, acceleration *0.8* delta)

			if(_axisresult.z <= -0.5):
				forward_speed = _axisresult.z * speedtemp
				Animleg.play("swimmove")
			else: #backward
				forward_speed =( _axisresult.z * speedtemp ) / 2
				Animleg.play("swimidle",-1,2.0)
			velocity = transform.basis.z * forward_speed
			if(targetchoice != null):
				velocity += transform.basis.x * side_speed










		elif(lpadstick != Vector2.ZERO) :   #   pad MOVMENTS
			if(targetchoice == null):
				if(abs(lpadstick.x) > 0.25):
					rotation_degrees.y = rotation_degrees.y - lpadstick.x  * speedturn
			else : 
				if(abs(lpadstick.x) > 0.25):
					side_speed = jloutput.x * speedtemp
				else:
					side_speed = 0
				look_at(targetchoice.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
			speedtemp = lerp(speedtemp, speed * 0.8, acceleration *0.8* delta)
			if(lpadstick.y < -0.5): #forward
				forward_speed = lpadstick.y * speedtemp
				Animleg.play("swimmove")
			else: #backward
				forward_speed =( lpadstick.y * speedtemp) / 2
				Animleg.play("swimidle",-1,2.0)
			rotation_degrees.x = 0
			rotation_degrees.z = 0

			velocity = transform.basis.z * forward_speed# Movement is always forward
			if(targetchoice != null):
				velocity += transform.basis.x * side_speed


		else: #don't move
			speedtemp = lerp(speedtemp, 0, acceleration * delta * 5)
			velocity.x = lerp(velocity.x,0.0,0.2)
			velocity.z = lerp(velocity.z,0.0,0.2 )
			Animleg.play("swimidle")
#		gravity_speed -=  mass * delta # Gravity
		velocity.y = 0.0

		gravity_speed = move_and_slide(velocity, Vector3(0,1,0), true,2,0.785398,false).y

	elif(mode == "onrail"):
		global_transform.origin = railcut.global_transform.origin
		rotation_degrees = railcut.rotation_degrees
		Animleg.play("Idle")
		
	elif(mode == "showingobj"):
		#cam au sol, dialogue
		get_tree().current_scene.find_node("Audiomusic",true,false).volume_db = -12
		get_node("Spring/SpringArm").rotation_degrees = lerp(get_node("Spring/SpringArm").rotation_degrees,Vector3(30,0,0),delta * 3)
		get_node("Spring/SpringArm").spring_length = lerp(get_node("Spring/SpringArm").spring_length,3,0.1)
		if(get_node("sound").is_playing() == false):
			mode = ""
			get_tree().current_scene.find_node("Audiomusic",true,false).volume_db = 0
			get_node("Spring/SpringArm").spring_length = 4
			Animleg.play_backwards("getgreatbonushalf")
			get_parent()._closetextbox()
			
	elif(mode == "cutscene"):
		pass
			
	elif(mode == "dead"):
		get_node("Spring/SpringArm/Camera").rotation_degrees.x = lerp(get_node("Spring/SpringArm/Camera").rotation_degrees.x,-40.0,0.01)
		get_node("Spring").rotation_degrees.y +=1
		get_node("CollisionShape").disabled = true
		get_node("reset").visible = true
			
			
			
			
			
			
func _shooted(who):
	if(Animarm.current_animation != "shield"):
		get_node("mesh/leg").play("fall")
		mode = "falling"
		velocity = transform.basis.z * 30
		_receivedamage(1)
		get_node("hitted/AnimationPlayer").play("Anim")
	else:
		_playsound("shield")
func _sworded():
	if(Animarm.current_animation != "shield"):
		get_node("mesh/leg").play("fall")
		mode = "falling"
		velocity = transform.basis.z * 30
		_receivedamage(1)
		get_node("hitted/AnimationPlayer").play("Anim")
	else:
		_playsound("shield")



func _receivedamage(amount):
		Global.mot.life -= amount
		_updatehud()




func _on_J2_pressed():
	if(targetchoice != null):
		if(ground_ray.is_colliding()):
			jump = 1
	else:
		if(ground_ray.is_colliding()):
			jump = 1

func _getpoh():#piece of heart
	Global.mot.poh += 1
	_playsound("greatbonus")
	Animleg.play("getgreatbonushalf")
	mode = "showingobj"

	if(Global.mot.poh >= 4):
		Global.mot.lifemax += 1
		Global.mot.poh = 0
	get_parent()._opendtextbox("poh"+str(Global.mot.poh))
	_getlife(10.0)

	
func _getkey():#small key
	_playsound("greatbonus")
	Animleg.play("getgreatbonushalf")
	mode = "showingobj"
	get_parent()._opendtextbox("key")

func _getswitch():#switch arm
	_playsound("greatbonus")
	Animleg.play("getgreatbonushalf")
	mode = "showingobj"
	get_parent()._opendtextbox("switcharm")
	
func _getlife(amount):
	Global.mot.life += amount
	if(Global.mot.life > Global.mot.lifemax):
		Global.mot.life = Global.mot.lifemax
	_updatehud()
	
func _getmoney(amount):
	Global.mot.money += amount
	if(Global.mot.life > Global.mot.lifemax):
		Global.mot.life = Global.mot.lifemax
	_updatehud()

func _getarrow(amount):
	Global.mot.arrows += amount
	if(Global.mot.arrows > Global.mot.arrowsmax):
		Global.mot.arrows = Global.mot.arrowsmax
	_updatehud()



func _on_hookblade_body_entered(body):
	if(mode == "hooking"):
		if(body.has_method("_hooked")):
			body._hooked()
			
			
		hooktarget = get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade").global_transform.origin 
		mode = "hooked"

func _hook():
	if(get_node("guncast").get_collider() != null):
		Animleg.play("Idle",0)
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").look_at(get_node("guncast").get_collision_point(),Vector3.UP )
		get_node("mesh/gun").play("hook")
		mode = "hooking"
	else:
		
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").look_at(get_node("Spring/SpringArm/Camera").project_position(get_node("hud/targetbow").position, 100.0),Vector3.UP )
		get_node("mesh/gun").play("hook")
		mode = "hooking"

func _shootarrow():
	_playsound("bow")
	var newarrow = arrow.instance()
	get_parent().add_child(newarrow)
	get_node("guncast").add_exception(newarrow)
	newarrow.add_collision_exception_with(self) # Add it to bullet.
	newarrow.add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword")) # Add it to bullet.
	newarrow.add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade")) # Add it to bullet.
	newarrow.add_collision_exception_with(get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield")) # Add it to bullet.
	if(get_node("guncast").get_collider() != null):
		newarrow.look_at_from_position(get_node("guncast").global_transform.origin,get_node("guncast").get_collision_point(),Vector3.UP )
	else:
		newarrow.look_at_from_position(get_node("guncast").global_transform.origin, get_node("Spring/SpringArm/Camera").project_position(get_node("hud/targetbow").position, 50.0)    ,Vector3.UP )
	newarrow.set_linear_velocity((newarrow.get_global_transform().basis[2].normalized()) * -25)

func _updatehud():
	if(targetlist.size() > 0):
		get_node("hud/C/targetp").modulate = "88ffe300"
	else:
		get_node("hud/C/targetp").modulate = "a721201b"
	get_node("hud/A/weapon").visible = true
	get_node("hud/A/obj").visible = false
	get_node("hud/A/ammo").visible = false
	get_node("hud/targetbow").visible = false
	get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield/CollisionShape").set_deferred("disabled" , true)

	if(currentweapon == "sword"):
			get_node("bag/inventory/weapons/cursor").position = get_node("bag/inventory/weapons/sword").rect_position
			get_node("hud/A/weapon").set_texture(preload("res://asset/textures/mot/swordicon.png"))
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = true
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield/CollisionShape").set_deferred("disabled" , false)
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").visible = true
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/bow").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").visible = false
	if(currentweapon == "bow"):
			get_node("bag/inventory/weapons/cursor").position = get_node("bag/inventory/weapons/bow").rect_position
			get_node("hud/A/weapon").set_texture(preload("res://asset/textures/mot/bowicon.png"))
			get_node("hud/A/ammo").visible = true
			get_node("hud/A/ammo").set_text(str(Global.mot.arrows))
			get_node("guncast").set_cast_to(Vector3(0,0,-50))
			get_node("hud/targetbow").visible = true
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/bow").visible = true
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").visible = false
	if(currentweapon == "hook"):
			get_node("bag/inventory/weapons/cursor").position = get_node("bag/inventory/weapons/hook").rect_position
			get_node("hud/A/weapon").set_texture(preload("res://asset/textures/mot/hookicon.png"))
			get_node("guncast").set_cast_to(Vector3(0,0,-23))
			get_node("hud/targetbow").visible = true
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/bow").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").visible = true


	if(closeobject != null): # weapon icon
		get_node("hud/A/weapon").visible = false
		get_node("hud/A/obj").visible = true
		if(closeobject.has_method("_dooricon")): # obj icon
			get_node("hud/A/obj").set_texture(preload("res://asset/textures/32text/32door2.png"))
		if(closeobject.has_method("_switchicon")): # obj icon
			get_node("hud/A/obj").set_texture(preload("res://asset/textures/mot/switch.png"))
		if(closeobject.has_method("_talkicon")): # obj icon
			get_node("hud/A/obj").set_texture(preload("res://asset/textures/mot/talk.png"))


	var lifeint = round(Global.mot.life)
	for i0 in get_node("life/hearts").get_children():
		i0.visible = true
	for i in get_node("life/hearts").get_children():
		if(str2var(i.name ) > lifeint):
			i.visible = false

	if(Global.mot.life <= 0):
		_die()
		return
	var backlifeint = round(Global.mot.lifemax)
	
	for i0 in get_node("life/top").get_children():
		i0.visible = true
	for i01 in get_node("life/top").get_children():
		if(str2var(i01.name ) > backlifeint):
			i01.visible = false
			

	if(mode == "swim"):
		get_node("hud/A").visible = false
		get_node("B").visible = false
		get_node("hud/J2").visible = false
		get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = false
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").visible = false
		get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/bow").visible = false
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook").visible = false
	else:
		get_node("hud/A").visible = true
		get_node("B").visible = true
		get_node("hud/J2").visible = true


func _die():

		mode = "dead"
		_showhidehud("hide")
		set_process(false)
		Animleg.play("die")


		
func _showhidehud(what):
	if(what == "hide"):
		get_node("hud").visible = false
		get_node("B").visible = false
		get_node("life").visible = false

	if(what == "show"):
		get_node("hud").visible = true
		get_node("B").visible = true
		get_node("life").visible = true

func _playsound(what):
	get_node("sound").set_volume_db(0)
	get_node("sound").set_pitch_scale(1.0)
	if(what == "findobject"):
		get_node("sound").set_stream(preload("res://asset/sounds/victory1.wav"))
	elif(what == "clic"):
		get_node("sound").set_stream(preload("res://asset/sounds/tac1.wav"))
	elif(what == "grid"):
		get_node("sound").set_stream(preload("res://asset/sounds/object1.wav"))
	elif(what == "biggrid"):
		get_node("sound").set_volume_db(12)
		get_node("sound").set_pitch_scale(0.65)
		get_node("sound").set_stream(preload("res://asset/sounds/object1.wav"))
	elif(what == "boom"):
		get_node("sound").set_stream(preload("res://asset/sounds/fireball1.wav"))
	elif(what == "object2"):
		get_node("sound").set_stream(preload("res://asset/sounds/object2.wav"))
	elif(what == "object3"):
		get_node("sound").set_stream(preload("res://asset/sounds/object3.wav"))
	elif(what == "error"):
		get_node("sound").set_stream(preload("res://asset/sounds/error.wav"))
	elif(what == "dooropen"):
		get_node("sound").set_volume_db(-12)
		get_node("sound").set_stream(preload("res://asset/sounds/door1.wav"))
	elif(what == "doorclose"):
		get_node("sound").set_volume_db(-12)
		get_node("sound").set_stream(preload("res://asset/sounds/doorclose.wav"))
	elif(what == "getcoin"):
		get_node("sound").set_stream(preload("res://asset/sounds/getcoin.wav"))
	elif(what == "getheart"):
		get_node("sound").set_stream(preload("res://asset/sounds/bonus1.wav"))
	elif(what == "fallinhole"):
		get_node("sound").set_stream(preload("res://asset/sounds/fallinhole.wav"))
		
	elif(what == "jump"):
		get_node("sound").set_pitch_scale(0.5)
		get_node("sound").set_volume_db(-6)
		get_node("sound").set_stream(preload("res://asset/sounds/jump.wav"))
	elif(what == "hitted"):
		get_node("sound").set_stream(preload("res://asset/sounds/hitted.wav"))

	elif(what == "sword"):
	#	get_node("sound").set_pitch_scale(0.7)
		get_node("sound").set_stream(preload("res://asset/sounds/sword2.wav"))
		
		
	elif(what == "shield"):
		get_node("sound").set_stream(preload("res://asset/sounds/swordshield.wav"))
	elif(what == "bow"):
		get_node("sound").set_stream(preload("res://asset/sounds/arrowshot.wav"))
	elif(what == "hook"):
		get_node("sound").set_volume_db(-18)
		get_node("sound").set_pitch_scale(4)
		get_node("sound").set_stream(preload("res://asset/sounds/hook1.wav"))
	elif(what == "greatbonus"):
		get_node("sound").set_stream(preload("res://asset/sounds/greatbonus.ogg"))

	get_node("sound").play()

func _playanim(what):
	if(what == "walk"):
		Animleg.play("Walk")
	elif(what == "idle"):
		Animleg.play("Idleanimated")
	elif(what == "wake"):
		Animleg.play("wake",-1,0.2)
	elif(what == "mouth"):
		get_node("mesh/gun").play("talk")
	elif(what == "fall"):
		Animleg.play("fall")
	elif(what == "wakespeed"):
		Animleg.play("wake")
	elif(what == "sword"):
		Animleg.play("sword")
	elif(what == "hide"):
		Animleg.play("hide")



func _on_targetzone_body_entered(body):
	if(body.has_method("_targetable")):
		targetlist.append(body)
		_updatehud()
		
func _swordattack():
	_playsound("sword")

func _on_targetzone_body_exited(body):
	if(body.has_method("_targetable")):
		targetlist.erase(body)
		_updatehud()

func _on_A_pressed():
	if(get_node("Spring/SpringArm/Camera").current == true and (mode == "" or mode == "talking")):
		if(closeobject == null):
			if(currentweapon == "sword"):
				Animarm.play("sword")

			if(currentweapon == "bow"):
				if(Global.mot.arrows > 0 and Animarm.is_playing() == false):
					Animarm.play("bowcomplete")
					Global.mot.arrows -= 1
					_updatehud()
					
					
					
			if(currentweapon == "hook"):
				get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/hook/blade/CollisionShape").disabled = false
				Animarm.play("hook")

		else:
			closeobject._action()

func _on_B_pressed():
	if(mode == "bag"):
		_bag("close")
		mode = ""
		get_parent()._bag("close")
	elif(mode == ""):
		_bag("open")
		mode = "bag"
		get_parent()._bag("open")

func _bag(what):
	_updatehud()
	if(what == "open"):
		get_node("hud").rect_position = Vector2(2000,2000)
		get_node("bag").visible = true
		for i in get_node("bag/map").get_children():#remove cloud on map
			i.visible = true
			if(Global.mot.places.find( i.name ) != -1):
				i.visible = false
		for i2 in get_node("bag/inventory/weapons").get_children():#remove weapons
			i2.visible = true
			if(Global.mot.inventory.find( i2.name ) == -1):
				if(i2.name) != "cursor" :
					i2.visible = false

		for i3 in get_node("bag/inventory/stuff").get_children():#remove stuff
			i3.visible = true
			if(Global.mot.stuff.find( i3.name ) == -1):
				i3.visible = false


		for i35 in get_node("bag/inventory/heart").get_children() :# piece of heart
			i35.visible = false
			
			
		for i4 in Global.mot.poh :# piece of heart
			get_node("bag/inventory/heart").get_child(i4).visible = true
			
			
		for i5 in get_node("bag/inventory/stones").get_children():#remove stones
			i5.visible = true
			if(Global.mot.stones.find( i5.name ) == -1):
				i5.visible = false


		get_node("bag/inventory/weapons/bow/bow/Label").set_text(str(Global.mot.arrows))
		get_node("bag/inventory/stuff/cash/Label").set_text(str(Global.mot.money))
		get_node("bag/inventory/stuff/skull/Label").set_text(str(Global.mot.skull))

			#show invent / money
		if(get_parent().name == "beach" or get_parent().name == "boatinside"):
			get_node("bag/map/cursor").position = Vector2(60,92)
			get_node("bag/map/aera").set_text("Beach")
			
		if(get_parent().name == "forest1"):
			get_node("bag/map/cursor").position = Vector2(18,65)
			get_node("bag/map/aera").set_text("Kalki Forest")
			
		if(get_parent().name == "forest2" or get_parent().name == "forestcaves"):
			get_node("bag/map/cursor").position = Vector2(20,40)
			get_node("bag/map/aera").set_text("Kalki Forest")

		if(get_parent().name == "temple1" or get_parent().name == "Temple1inside"):
			get_node("bag/map/cursor").position = Vector2(26,16)
			get_node("bag/map/aera").set_text("Patrick Manor")
			
			
	elif(what == "close"):
		get_node("hud").rect_position = Vector2(0,0)
		get_node("bag").visible = false

func _on_C_pressed():
	if(targetlist.size() > 0):
		if(targetchoice == null):
			var tempclosest
			var closestdist
			for i in targetlist.size() :
				if(i == 0):
					tempclosest = targetlist[i]
					closestdist = global_transform.origin.distance_to(targetlist[i].global_transform.origin)
				else:
					if(global_transform.origin.distance_to(targetlist[i].global_transform.origin) < closestdist ):
						tempclosest = targetlist[i]
			targetchoice = tempclosest
			get_node("sound").set_stream(preload("res://asset/sounds/target.wav"))
			get_node("sound").play()
			#find the closest and target it
			#if(targetlist.find(targetchoice))
		else:
			targetchoice = null
			get_node("sound").set_stream(preload("res://asset/sounds/targetout.wav"))
			get_node("sound").play()
	else:
		targetchoice = null
		get_node("sound").set_stream(preload("res://asset/sounds/targetout.wav"))
		get_node("sound").play()
	if(targetchoice != null):
		if(targetchoice.get("state") ):
			if(targetchoice.state == "dead"):
				targetchoice = null


func _on_sword_pressed():
	currentweapon = "sword"
	Global.mot.currentweapon = "sword"
	_updatehud()
func _on_bow_pressed():
	currentweapon = "bow"
	Global.mot.currentweapon = "bow"
	_updatehud()
func _on_hook_pressed():
	currentweapon = "hook"
	Global.mot.currentweapon = "hook"
	_updatehud()


func _on_textspeed_timeout():
	get_parent()._on_textspeed_timeout()

func _talk(what):
	get_parent()._talk(what)

func _on_top_area_entered(area):
	mode = "swim"
	get_node("watermove/AnimationPlayer").play("water")
	_updatehud()

func _on_top_area_exited(area):
	mode = ""
	Animleg.play("Idle")
	get_node("watermove/AnimationPlayer").play("waterstop")
	_updatehud()


func _on_reset_pressed():
	Global.mot.life = 3
	Global.mot.changescene = "res://scenes/monsteroftime/boatinside.tscn"
	Global.mot.spawn = ""
	get_tree().change_scene("res://scenes/monsteroftime/motmenu.tscn")
