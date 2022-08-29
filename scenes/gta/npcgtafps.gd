extends KinematicBody
onready var humanmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/head"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handr"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handl"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/hips")]
onready var humanmeshesF = [get_node("mesh/Armature/Bone/Bone001/Bone002/head"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handr"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handl"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/hipsF")]
onready var humanmeshes2 = [get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/hipsF")]
onready var skelmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/headskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlskel"),get_node("mesh/Armature/Bone/Bone001/chestskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrskel"),get_node("mesh/Armature/Bone/Bone009/ulegrskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglskel"),get_node("mesh/Armature/Bone/Bone012/uleglskel"),get_node("mesh/Armature/Bone/hipsskel")]

onready var rng = RandomNumberGenerator.new()
onready var player = get_tree().current_scene.find_node("KineFPS",true,false)
onready var mainnode = player.get_parent()
onready var Animgun = get_node("mesh/gun")
onready var Animarm = get_node("mesh/arm")
onready var Animleg = get_node("mesh/leg")
var npctype = "common"
var clothnb
var clotharray
var clothmat
var facemat
var hairmat
var gender = 0
var move = 0 #yes/no
var target_pos
var move_vec
var die = 0
var falling = 0
var speed = 3.0
var life = 100.0
var isattack = 0
var rotdir = 6.0
var close = 0
var closelist = []
var vcloselist = []
func _ready():
	if(get_parent().name == "zombie"): # for menu cutscene
		speed = 0.1
		rotation_degrees.y = rng.randi_range(0,360)
	else :
		look_at(player.global_transform.origin,Vector3.UP)
		rotation_degrees.z = 0
		rotation_degrees.x = 0
	rng.randomize()
	add_to_group("enemies")

	if(rng.randi_range(1,2) == 1):
		rotdir = 6.0
	else:
		rotdir = - 6.0


	var temptype = rng.randi_range(1,6)
	if(temptype == 1): 
		npctype = "skel"
		for i in humanmeshes:
			i.queue_free()
		for i2 in humanmeshes2:
			i2.queue_free()
		speed *= 1.2
		Animleg.playback_speed = 1.2
	if(temptype > 1): 
		npctype = "zomb"
		speed *= 0.8
		Animleg.playback_speed = 0.8
		gender = rng.randi_range(1,2) #1 M // 2 F.
		if(gender == 1): #M
				var facenb = rng.randi_range(1,2)
				if(facenb == 1):
					facemat = load("res://asset/materials/facezombm1.tres")
					hairmat =  load("res://asset/materials/hairbrown.tres")
				elif(facenb == 2):
					facemat = load("res://asset/materials/facezombm2.tres")
					hairmat =  load("res://asset/materials/hairblond.tres")
				get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
				get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
				clotharray = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
				var clotharraytodelete =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF")]
				for idelete in clotharraytodelete :
					idelete.queue_free()
		elif(gender == 2):#F
				var facenb = rng.randi_range(1,2)
				if(facenb == 1):
					facemat = load("res://asset/materials/facezombf1.tres")
					hairmat =  load("res://asset/materials/hairbrown.tres")
				elif(facenb == 2):
					facemat = load("res://asset/materials/facezombf2.tres")
					hairmat =  load("res://asset/materials/hairblond.tres")
				get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
				get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
				var clotharraytodelete = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl")]
				clotharray =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
				for idelete in clotharraytodelete :
					idelete.queue_free()

		var skelpartnb = rng.randi_range(0,8)
		var skelpart 
		var keeppart = []

		if(gender == 1):
			for ipart in skelpartnb :
				skelpart  = rng.randi_range(0,14)
				humanmeshes[skelpart].visible = false
				if(clotharray.find(humanmeshes[skelpart])!= -1 ):
					clotharray.erase(humanmeshes[skelpart])
				keeppart.append(skelpart)
		elif(gender == 2):
			for ipart in skelpartnb :
				skelpart  = rng.randi_range(0,14)
				humanmeshesF[skelpart].visible = false
				if(clotharray.find(humanmeshesF[skelpart])!= -1 ):
					clotharray.erase(humanmeshesF[skelpart])
				keeppart.append(skelpart)

		for i in skelmeshes.size():
			if(keeppart.find(i) == -1):
				skelmeshes[i].queue_free()
			
		clothnb = rng.randi_range(1,6)
		if(clothnb == 1):
				clothmat = load("res://asset/materials/clothzomb1.tres")
		elif(clothnb == 2):
				clothmat = load("res://asset/materials/clothzomb2.tres")
		elif(clothnb == 3):
				clothmat = load("res://asset/materials/clothzomb3.tres")
		elif(clothnb == 4):
				clothmat = load("res://asset/materials/clothzomb4.tres")
		elif(clothnb == 5):
				clothmat = load("res://asset/materials/clothzomb5.tres")
		elif(clothnb == 6):
				clothmat = load("res://asset/materials/clothzomb6.tres")
		clothmat = clothmat.duplicate()
		for i in clotharray :
			i.set_surface_material(0,clothmat)
	if(temptype > 4): 
		get_node("mesh/Armature/Bone/Bone001/Bone002/head/mouth").visible = true
	Animleg.play("walkzombie")


func _process(delta):
	if(vcloselist.size() != 0): # IF ENEMY VERY CLOSE, WALK TO IT & ATTACK
		move_vec = vcloselist[0].global_transform.origin - global_transform.origin
		move_and_slide(move_vec.normalized() * speed,Vector3.UP)
		if(Animleg.is_playing() == false):
			isattack = 0
			if(npctype == "zomb"):
				get_node("mesh/Armature/Bone/Bone001/Bone002/head/mouth").visible = false
			elif(npctype == "skel"):
				get_node("mesh/Armature/Bone/Bone001/Bone002/headskel/mouth").visible = false
			get_node("mesh/AudioStreamPlayer").set_pitch_scale(rng.randf_range(0.5,1.2))
			look_at(vcloselist[0].global_transform.origin,Vector3.UP)
			rotation_degrees.z = 0
			rotation_degrees.x = 0
			Animleg.play("attakzombie")
		
	elif(closelist.size() != 0): # IF ENEMY VERY CLOSE, WALK TO IT
		move_vec = closelist[0].global_transform.origin - global_transform.origin
		move_and_slide(move_vec.normalized() * speed,Vector3.UP)
		look_at(closelist[0].global_transform.origin,Vector3.UP)
		rotation_degrees.z = 0
		rotation_degrees.x = 0
		
	else: # WALK AND TURN IF WALL
		if(is_on_wall()):
			rotation_degrees.y += rotdir
		move_vec  = -transform.basis.z * speed
		move_and_slide(move_vec,Vector3.UP)



func dying():
			mainnode.npcnear -= 1
			queue_free()


func fall():
	set_process(true)
	falling = 0
	if(close == 2):
		Animleg.play("attakzombie")
	else:
		Animleg.play("walkzombie")

	
	
func _shooted(who,strength):
	if(Animleg.current_animation != "fall" and die == 0):
		_receivedamage(strength,"")
		look_at(who.global_transform.origin,Vector3(0,1,0))
		rotation_degrees.z = 0
		rotation_degrees.x = 0
	else:
		return

#func _cared(amount):
#	if(falling == 0 and die == 0):
#		_receivedamage(amount,"car")

func _receivedamage(amount,type):
		isattack = 0
		life -= amount

		if(life <= 0):
			die = 1
			set_process(false)
			Animleg.play("die")
			if(npctype == "zomb"):
				mainnode._spawnblood(global_transform.origin,"big")
			get_node("CollisionShape").queue_free()
		else:
		#	if(Animleg.current_animation != "fall"):
				falling = 1
				set_process(false)
				Animleg.play("fall")
				target_pos = null
				if(npctype == "zomb"):
					mainnode._spawnblood(global_transform.origin,"small")
		
		
		
		
		
func _npc():
	pass
func _zombie():
	pass


func _on_Areatoofar_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		mainnode.npcnear -= 1
		queue_free()



func _on_Areaclose_body_entered(body):
	if(body.has_method("_on_J2_pressed") or body.has_method("_relativ")):
		closelist.append(body)
		close = 1


func _on_Areaclose_body_exited(body):
	if(body.has_method("_on_J2_pressed") or body.has_method("_relativ")):
		close = 0
		closelist.erase(body)


func _on_Areacac_body_entered(body):
	if(body.has_method("_on_J2_pressed") or body.has_method("_relativ")):
		if(die == 0 and falling == 0):
			Animleg.stop()
		close = 2
		vcloselist.append(body)

func _on_Areacac_body_exited(body):
	if(body.has_method("_on_J2_pressed") or body.has_method("_relativ")):
		close = 1
		vcloselist.erase(body)


func _on_hand_body_entered(body):
	if(body.has_method("_on_J2_pressed") or body.has_method("_relativ")):
		if(isattack == 1):
			body._sworded(100)




func _swordattack():
	isattack = 1
	if(npctype == "zomb"):
		get_node("mesh/Armature/Bone/Bone001/Bone002/head/mouth").visible = true
	if(npctype == "skel"):
		get_node("mesh/Armature/Bone/Bone001/Bone002/headskel/mouth").visible = true
