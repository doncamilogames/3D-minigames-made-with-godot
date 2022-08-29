extends KinematicBody

onready var rng = RandomNumberGenerator.new()
onready var player = get_tree().current_scene.find_node("Kinemacron")
onready var Animgun = get_node("mesh/gun")
onready var Animarm = get_node("mesh/Animarm")
var npctype = "common"
var enemycolor = ""
var clothnb
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
var life = 100.0
var favdir = 1.0
var swording = 0
var chasing = 0
var rotdir = 6.0
var flee = 0
var enemyweapon
var pdist 
var pmodedist
func _ready():
	rng.randomize()


	gender = rng.randi_range(1,2) #1 M // 2 F
	if(gender == 1):
			facemat = load("res://scenes/gta/npc/faceM1.tres")
			get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
			clotharray = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
			#delete F parts
			var clotharraytodelete =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
			for idelete in clotharraytodelete :
				idelete.queue_free()
	if(gender == 2):
			facemat = load("res://scenes/gta/npc/faceF1.tres")
			get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
			var clotharraytodelete = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
			#delete M parts
			clotharray =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
			for idelete in clotharraytodelete :
				idelete.queue_free()

	if(Global.gtc.get(Global.gtc.modeselected + "currentcrime") > 0.0):
		if(rng.randf_range(0.0,10.0) <  Global.gtc.get(Global.gtc.modeselected + "currentcrime")): #full crime = only cops, no crime =  no cop
			npctype = "cop"
			life = 250.0
			enemyweapon = "gun"

	if(get_parent().mode == "Arcade"):
		if(get_parent().currentarea != ""): # enemy if in area and if not all killed or spawned
			if(Global.gtc.Arcadeenemies.get(get_parent().currentarea) - get_tree().get_nodes_in_group(get_parent().currentarea).size() > 0):
				if(rng.randi_range(1,10) > 5):
					npctype = "ennemy"
					enemycolor = get_parent().currentarea # G1.2.3.4...R1 B1 Y1....
					add_to_group(enemycolor)

					if(Global.gtc.Arcadeenemies.get(get_parent().currentarea) - get_tree().get_nodes_in_group(get_parent().currentarea).size() >= 3):
						enemyweapon = "bat"
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = true
					elif(Global.gtc.Arcadeenemies.get(get_parent().currentarea) - get_tree().get_nodes_in_group(get_parent().currentarea).size() < 3 and Global.gtc.Arcadeenemies.get(get_parent().currentarea) - get_tree().get_nodes_in_group(get_parent().currentarea).size() > 0):
						enemyweapon = "gun"
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = true
					else:
						enemyweapon = "mgun"
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/mgun").visible = true
					life = 200.0

	if(npctype == "common"):
		get_node("mesh/Armature/Bone/Bone001/Bone002/hat1").queue_free()
		clothnb = rng.randi_range(1,6)
		if(clothnb == 1):
				clothmat = load("res://asset/materials/clothnpc1.tres")
		if(clothnb == 2):
				clothmat = load("res://asset/materials/clothnpc2.tres")
		if(clothnb == 3):
				clothmat = load("res://asset/materials/clothnpc3.tres")
		if(clothnb == 4):
				clothmat = load("res://asset/materials/clothnpc4.tres")
		if(clothnb == 5):
				clothmat = load("res://asset/materials/clothnpc5.tres")
		if(clothnb == 6):
				clothmat = load("res://asset/materials/clothnpc6.tres")
		clothmat = clothmat.duplicate()
		for i in clotharray :
			i.set_surface_material(0,clothmat)

	if(npctype == "cop"):
		get_node("mesh/Armature/Bone/Bone001/Bone002/hat1").visible = true
		clothmat = load("res://asset/materials/clothnpccop.tres")
		clothmat = clothmat.duplicate()
		for i in clotharray :
			i.set_surface_material(0,clothmat)

	if(npctype == "ennemy"):
		clothmat = load("res://asset/materials/clothnpcgang.tres")
		get_node("mesh/Armature/Bone/Bone001/Bone002/hat1").visible = true

		if("B" in enemycolor):
			clothmat.set_albedo("0081ff")
		if("G" in enemycolor):
			clothmat.set_albedo("5cff00")
		if("Y" in enemycolor):
			clothmat.set_albedo("ffc500")
		if("R" in enemycolor):
			clothmat.set_albedo("ff0000")
		clothmat = clothmat.duplicate()
		clotharray.append(get_node("mesh/Armature/Bone/Bone001/Bone002/hat1"))
		for i in clotharray :
			i.set_surface_material(0,clothmat)

func _process(delta):
	pdist = global_transform.origin.distance_to(player.global_transform.origin)
	if(swording == 1):
		if(Animarm.is_playing() == false):
			if(player.mode == "car"  or player.mode == "startcar"  or player.mode == "stopcar"):
				if(pdist < 5.0):
					player._shooted(self,20.0)
					get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
					get_node("weaponsound").play()
			else:
				if(pdist < 1.5):
					player._shooted(self,20.0)
					get_node("weaponsound").set_stream( preload("res://asset/sounds/poc1.wav"))
					get_node("weaponsound").play()
			swording = 0
	if(pdist > 40): # delete if too far from player
		get_parent().npcnear -= 1
		queue_free()
	if(die == 1 ):
		add_collision_exception_with(player)
		if( get_node("mesh/AnimationPlayer").is_playing() == false):
			get_parent().npcnear -= 1
			if(npctype == "ennemy" and get_parent().mode == "Arcade"):
				Global.gtc.Arcadeenemies[enemycolor] -=1
				player._updatehud()
				if(Global.gtc.Arcadeenemies[enemycolor] <= 0):
					get_parent()._updatearcadezones(enemycolor)

			if(npctype == "ennemy" ):
				var newammo
				if(enemyweapon == "bat"):#bat
					newammo = preload("res://scenes/gta/objects/batgrabable.tscn")
				if(enemyweapon == "gun"):#gun
					newammo = preload("res://scenes/gta/objects/gungrabable.tscn")
				if(enemyweapon == "mgun"):#gun
					newammo = preload("res://scenes/gta/objects/mgungrabable.tscn")

				newammo = newammo.instance()
				get_parent().add_child(newammo)
				newammo.global_transform.origin = global_transform.origin

			if(npctype == "cop" ):
					var newammo = preload("res://scenes/gta/objects/gungrabable.tscn")
					newammo = newammo.instance()
					get_parent().add_child(newammo)
					newammo.global_transform.origin = global_transform.origin

			var npccash = rng.randi_range(0,30)
			if(npccash > 5):
				var newcash = preload("res://scenes/gta/objects/cashgrabable.tscn")
				newcash = newcash.instance()
				get_parent().add_child(newcash)
				newcash.global_transform.origin = global_transform.origin
				newcash.cashnb = npccash
			queue_free()

	else :
		if(falling == 0):
			if(npctype == "cop"):
				if(pdist < 10.0 and Global.gtc.get(Global.gtc.modeselected + "currentcrime") > 0.0 ):# move to the player and attack
					if(player.chasingnpc.find(self) == -1):
						player.chasingnpc.append(self)
					if(Global.gtc.get(Global.gtc.modeselected + "currentcrime") < 5.0): # use bat
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = true
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = false
						if(player.mode == "car" or player.mode != "startcar"):
							pmodedist = 5.0
						else:
							pmodedist = 1.5
						if(pdist > pmodedist): #bat range
							target_pos = player.global_transform.origin
							move_vec = target_pos - global_transform.origin
							look_at(target_pos,Vector3.UP)

							move_and_slide(move_vec.normalized() * speed,Vector3.UP)
						else:
							target_pos = player.global_transform.origin
							move_vec = target_pos - global_transform.origin
							look_at(target_pos,Vector3.UP)

							move_and_slide(move_vec.normalized() * speed,Vector3.UP)
							_sword()
					else: # use gun 
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/bat").visible = false
						get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = true
						if(pdist > 6.0):#gun range
							target_pos = player.global_transform.origin
							move_vec = target_pos - global_transform.origin
							look_at(target_pos,Vector3.UP)

							move_and_slide(move_vec.normalized() * speed,Vector3.UP)
						else:
							target_pos = player.global_transform.origin
							get_node("mesh/Animarm").play("holdgun")
							look_at(target_pos,Vector3.UP)

							_shoot()
				else: #common move if too far or not wanted
					if(player.chasingnpc.find(self) != -1):
						player.chasingnpc.erase(self)
					if(target_pos == null):
						rotation_degrees.y += 6.0
				#		if(abs(rotation_degrees.y) >= 360):
				#			rotation_degrees.y = 0
						if(get_node("npc/RayCast").get_collider() != null):
							target_pos = get_node("npc/RayCast").get_collision_point()
							move_vec = target_pos - global_transform.origin
						return
					else:
						move_and_slide(move_vec.normalized() * speed,Vector3.UP)
						if(is_on_wall()):
							target_pos = null
						if(get_node("GroundRay").is_colliding() == false):
							target_pos = null
			elif(npctype == "ennemy"):
				if(pdist < 10.0 ):# move to the player and attack
					if(enemyweapon == "bat"): #bat
						if(player.mode == "car" or player.mode != "startcar"):
							pmodedist = 5.0
						else:
							pmodedist = 1.5
						if(pdist > pmodedist): #bat range
							target_pos = player.global_transform.origin
							move_vec = target_pos - global_transform.origin
							look_at(target_pos,Vector3.UP)
							move_and_slide(move_vec.normalized() * speed,Vector3.UP)
						else:
							target_pos = player.global_transform.origin
							look_at(target_pos,Vector3.UP)
							move_vec = target_pos - global_transform.origin
							move_and_slide(move_vec.normalized() * speed,Vector3.UP)
							_sword()
					if(enemyweapon == "gun" or enemyweapon == "mgun" ): # gun
						if(pdist > 6.0):#gun range
							target_pos = player.global_transform.origin
							move_vec = target_pos - global_transform.origin
							look_at(target_pos,Vector3.UP)
							move_and_slide(move_vec.normalized() * speed,Vector3.UP)
						else:
							target_pos = player.global_transform.origin
							get_node("mesh/Animarm").play("holdgun")
							look_at(target_pos,Vector3.UP)
							_shoot()


				else: #common move if too far or not wanted
					if(target_pos == null):
						rotation_degrees.y += 6.0
				#		if(abs(rotation_degrees.y) >= 360):
					#		rotation_degrees.y = 0
						if(get_node("npc/RayCast").get_collider() != null):
							target_pos = get_node("npc/RayCast").get_collision_point()
							move_vec = target_pos - global_transform.origin
						return
					else:
						move_and_slide(move_vec.normalized() * speed,Vector3.UP)
						if(is_on_wall()):
							target_pos = null
						if(get_node("GroundRay").is_colliding() == false):
							target_pos = null
			elif(npctype == "common"):
				if(target_pos == null):
					rotation_degrees.y += rotdir
				#	if(abs(rotation_degrees.y) >= 360):
				#		rotation_degrees.y = 0
					if(get_node("npc/RayCast").get_collider() != null):
						target_pos = get_node("npc/RayCast").get_collision_point()
						move_vec = target_pos - global_transform.origin
						favdir = rng.randi_range(1,2)
						if(favdir == 1):
							rotdir = 6.0
						if(favdir == 2):
							rotdir = - 6.0
					return
				else:
					move_and_slide(move_vec.normalized() * speed,Vector3.UP)
					if(is_on_wall()):
						target_pos = null
					if(get_node("GroundRay").is_colliding() == false):
						target_pos = null
						
			rotation_degrees.z = 0
			rotation_degrees.x = 0
		else: #fall
			if( get_node("mesh/AnimationPlayer").is_playing() == false):
				falling = 0
				get_node("mesh/AnimationPlayer").play("Walk")
				rotation_degrees.z = 0
				rotation_degrees.x = 0
func _shoot():
		if(Animgun.is_playing() == false):
			Animarm.play("holdgun")
			if(enemyweapon == "gun"):
				Animgun.play("shoot")
			if(enemyweapon == "mgun"):
				Animgun.play("mshoot",-1,2.5)
			get_node("weaponsound").set_stream( preload("res://asset/sounds/tac1.wav"))
			get_node("weaponsound").play()
			if(rng.randi_range(1,3) == 1):
				player._shooted(self,50.0)

func _sword():
		if(Animarm.is_playing() == false):
			swording = 1
			Animarm.play("AttackSword",-1,1.5)

func _shooted(who,strength):
	if( die == 0):
		_receivedamage(strength,"")
		look_at(who.global_transform.origin,Vector3(0,1,0))
		

func _cared(amount):
	if(falling == 0 and die == 0):
		_receivedamage(amount,"car")

func _receivedamage(amount,type):
		life -= amount
		if(life <= 0):
			if(player.chasingnpc.find(self) != -1):
				player.chasingnpc.erase(self)
			get_node("mesh/AnimationPlayer").play("die")
			die = 1
			get_parent()._spawnblood(global_transform.origin,"big")
			get_node("CollisionShape").queue_free()
		else:
			if(get_node("mesh/AnimationPlayer").current_animation != "fall"):
				get_node("mesh/AnimationPlayer").play("fall")
				falling = 1
				target_pos = null
			get_parent()._spawnblood(global_transform.origin,"small")

func _npc():
	pass
