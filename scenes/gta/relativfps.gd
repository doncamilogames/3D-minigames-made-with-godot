extends KinematicBody

onready var rng = RandomNumberGenerator.new()
onready var player = get_tree().current_scene.find_node("KineFPS",true,false)
onready var Animgun = get_node("mesh/gun")
onready var Animarm = get_node("mesh/Animarm")
onready var Animleg = get_node("mesh/Animleg")
export var npctype = "mother"

var clotharray
var clothmat
var facemat
var hairmat
var gender = 0
var move = 0 #yes/no
var path = []
var path_ind = 0
var target_pos
var move_vec
var die = 0
var falling = 0
var speed = 5.0
var life = 1000.0
var favdir = 1.0
var swording = 0
var rotdir = 6.0
var flee = 0
var weapon
var playerdist = "vclose"
var mode = "close"
var vcloselist = []
var closelist = []

func _ready():
	add_collision_exception_with(player)
	rng.randomize()
	add_to_group("relativ")
	if(npctype == "father"):
		gender = 1
		facemat = load("res://scenes/gta/npc/faceM1.tres")
		hairmat = load("res://asset/materials/hairbrown.tres")
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
		weapon = "gun"
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = true
		clothmat = load("res://asset/materials/clotharcade.tres")

	elif(npctype == "mother"):
		gender = 2
		facemat = load("res://scenes/gta/npc/faceF1.tres")
		hairmat = load("res://asset/materials/hairblond.tres")
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
		weapon = "bat"
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = true
		clothmat = load("res://asset/materials/clothnpc1.tres")

	elif(npctype == "brother"):
		gender = 1
		facemat = load("res://scenes/gta/npc/faceM6.tres")
		hairmat = load("res://asset/materials/hairbrown.tres")
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
		weapon = "mgun"
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/mgun").visible = true
		clothmat = load("res://asset/materials/clothnpc6.tres")

	elif(npctype == "sister"):
		gender = 2
		facemat = load("res://scenes/gta/npc/faceF2.tres")
		hairmat = load("res://asset/materials/hairblond.tres")
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
		weapon = "bat"
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = true
		clothmat = load("res://asset/materials/clothnpc5.tres")


	if(gender == 1):# M
			clotharray = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
			var clotharraytodelete =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
			for idelete in clotharraytodelete :
				idelete.queue_free()
	if(gender == 2):# F
			var clotharraytodelete = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
			clotharray =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
			for idelete in clotharraytodelete :
				idelete.queue_free()


	for i in clotharray :
		i.set_surface_material(0,clothmat)
	Animleg.play("Walk")





func _process(delta):
	if(die == 0):
		if(falling == 0):
			if(playerdist == "far"):# ALWAYS FOLLOW, CAN PUCH 
				Animleg.play("Walk")
				mode = "follow"
				target_pos = player.global_transform.origin
				move_vec = (target_pos - global_transform.origin).normalized() 
				move_and_slide(move_vec* speed,Vector3.UP)
				if(vcloselist.size() != 0): #PUNCH 
					target_pos = vcloselist[0].global_transform.origin
					if(weapon == "bat"):
						Animarm.play("AttackSword")
					else:
						Animarm.play("AttackHand")




			elif(playerdist == "close"): # FOLLOW OR WAIT, CAN PUCH OR SHOOT
				if(mode == "follow"):
					Animleg.play("Walk")
					target_pos = player.global_transform.origin
					move_vec = (target_pos - global_transform.origin).normalized() 
					move_and_slide(move_vec* speed,Vector3.UP)
				
				if(vcloselist.size() != 0): #PUNCH 
					target_pos = vcloselist[0].global_transform.origin
					move_vec = (target_pos - global_transform.origin).normalized() 
					move_and_slide(move_vec* speed,Vector3.UP)
					if(weapon == "bat"):
						Animarm.play("AttackSword")
					else:
						Animarm.play("AttackHand")
				elif(closelist.size() != 0): #SHOOT
					if(weapon == "gun"  or weapon == "mgun"):
						target_pos = closelist[0].global_transform.origin
						Animarm.play("holdgun")
						_shoot(closelist[0])


			elif(playerdist == "vclose"):# WAIT, CAN PUCH OR SHOOT
				Animleg.play("Idleanimated")
				mode = "close"
				if(vcloselist.size() != 0):
					target_pos = vcloselist[0].global_transform.origin
					move_vec = (target_pos - global_transform.origin).normalized() 
					move_and_slide(move_vec* speed,Vector3.UP)
					if(weapon == "bat"):
						Animarm.play("AttackSword")
					else:
						Animarm.play("AttackHand")
				elif(closelist.size() != 0):
					if(weapon == "gun"  or weapon == "mgun"):
						target_pos = closelist[0].global_transform.origin
						Animarm.play("holdgun")
						_shoot(closelist[0])
				else:
					if(Animarm.is_playing() == false):
						target_pos = player.global_transform.origin
			if(target_pos == null):
				target_pos = player.global_transform.origin

			look_at(target_pos,Vector3.UP)
			rotation_degrees.z = 0
			rotation_degrees.x = 0



		else: #fall
			if( Animleg.is_playing() == false):
				falling = 0
				Animleg.play("Walk")
				rotation_degrees.z = 0
				rotation_degrees.x = 0
				

func _shoot(who):
		if(Animgun.is_playing() == false):
			Animarm.play("holdgun")
			if(weapon == "gun"):
				Animgun.play("shoot",-1,0.5)
			if(weapon == "mgun"):
				Animgun.play("mshoot",-1,1.0)
			get_node("weaponsound").set_stream( preload("res://asset/sounds/tac1.wav"))
			get_node("weaponsound").play()
			if(rng.randi_range(1,2) == 1): 
				who._shooted(self,50.0) 



func _sword():
		if(Animarm.is_playing() == false):
			swording = 1
			Animarm.play("AttackSword",-1,1.5)



func _shooted(who,strength):
	if( die == 0 and falling == 0):
		_receivedamage(strength,"")
		look_at(who.global_transform.origin,Vector3(0,1,0))



func _sworded(strength):
	if( die == 0):
		_receivedamage(strength,"weapon")

func _receivedamage(amount,type):
		life -= amount
		Global.gtc.Zombierelativ.get(npctype)[4] = life
		player._updatehud()
		if(life <= 0):
			Animleg.play("die")
			die = 1
			get_parent()._spawnblood(global_transform.origin,"big")
			get_node("CollisionShape").queue_free()
			Global.gtc.Zombiegoods.erase(npctype)
			Global.gtc.Zombieswitch.append(str(npctype+"dead"))
			
		else:
			if(Animleg.current_animation != "fall"):
				Animleg.play("fall")
				falling = 1
				target_pos = null
			get_parent()._spawnblood(global_transform.origin,"small")

func _npc():
	pass
func _relativ():
	pass

func _on_Areaclose_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		playerdist = "close"
	if(body.has_method("_zombie")):
		closelist.append(body)

func _on_Areaclose_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		playerdist = "far"
	if(body.has_method("_zombie")):
		closelist.erase(body)


func _on_Areacac_body_entered(body):
	if(body.has_method("_zombie")):
		vcloselist.append(body)
		
		
		
	if(body.has_method("_on_J2_pressed")):
		playerdist = "vclose"
		
		
func _on_Areacac_body_exited(body):
	if(body.has_method("_zombie")):
		vcloselist.erase(body)
	if(body.has_method("_on_J2_pressed")):
		playerdist = "close"


func _on_Areapunch_body_entered(body):
	if(Animarm.current_animation == "AttackHand"): 
		if(body.has_method("_shooted") and body.has_method("_zombie")):
			get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
			get_node("weaponsound").play()
			body._shooted(self,20)


func _on_Areabat_body_entered(body):
	if(Animarm.current_animation == "AttackSword"): 
		if(body.has_method("_shooted") and body.has_method("_zombie")):
			get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
			get_node("weaponsound").play()
			body._shooted(self,30)
