extends KinematicBody

onready var rng = RandomNumberGenerator.new()
onready var player
var npctype
var clothnb
var clotharray
var clothmat
var facemat
var hairmat
var move = 0 #yes/no
var path = []
var path_ind = 0
var target_pos
var move_vec
var die = 0
var speed = 5.0
export var _specialnpc = ""
export var _action = ""
export var gender = 0
var needprocess = 0


func _ready():
	
	if(Global.gtc.modeselected == "Zombie"):
		player = get_tree().current_scene.find_node("KineFPS",true,false)
	else:
		player = get_tree().current_scene.find_node("Kinemacron",true,false)
	
	rng.randomize()
	if(_specialnpc == ""):
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
				#delete F parts
				clotharray =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
				for idelete in clotharraytodelete :
					idelete.queue_free()#all body part meshes depending of the  cloth# CHEST, HIPS, ARM * 4, LEG * 6 
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

	else:
		gender = Global.gtanpc.get(_specialnpc)[0]
		facemat = load(Global.gtanpc.get(_specialnpc)[2])
		clothmat = load(Global.gtanpc.get(_specialnpc)[1])
		hairmat = load(Global.gtanpc.get(_specialnpc)[3])
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
		
		if(gender == 1):
				clotharray = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
				var clotharraytodelete =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
				for idelete in clotharraytodelete :
					idelete.queue_free()
		if(gender == 2):
				var clotharraytodelete = [get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/hips"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl")]
				clotharray =  [get_node("mesh/Armature/Bone/Bone001/chestF"),get_node("mesh/Armature/Bone/hipsF"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrF"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrF"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlF"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlF"),get_node("mesh/Armature/Bone/Bone009/ulegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrF"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrF"),get_node("mesh/Armature/Bone/Bone012/uleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglF"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlF")]
				for idelete in clotharraytodelete :
					idelete.queue_free()#all body part meshes depending of the  cloth# CHEST, HIPS, ARM * 4, LEG * 6 
		clothmat = clothmat.duplicate()
		for i in clotharray :
			i.set_surface_material(0,clothmat)



	if(_action != ""):
		_playanim(_action)




func _findwheretogo():
	get_node("npc/AnimationPlayer").play("findtrot")
	get_node("npc/RayCast").enabled = true

func _shooted(who):
	if(die == 0):
		look_at(who.global_transform.origin,Vector3(0,1,0))
		rotation_degrees.y -= 180
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		get_node("mesh/AnimationPlayer").play("die")
		die = 1
		get_parent()._spawnblood(global_transform.origin)


func _cared(amount):
	if(die == 0):
		get_node("mesh/AnimationPlayer").play("die")
		die = 1
		get_parent()._spawnblood(global_transform.origin)
		

func _playanim(what):
	if what == "talk":
		get_node("mesh/AnimationPlayer").play("shakehand",-1,0.1)
	if what == "mouth":
		get_node("mesh/animouth").play("mouth")
	if what == "walk":
		get_node("mesh/Animleg").play("Walk")
		
	if what == "tophand":
		get_node("mesh/Animleg").play("tophand")
	if what == "climbwall":
		get_node("mesh/Animleg").play("climbwall")
	if what == "swim":
		get_node("mesh/Animleg").play("swimidle")
	if what == "idle":
		get_node("mesh/Animleg").play("IdleAll")
	if what == "idleanim":
		get_node("mesh/Animleg").play("Idleanimated")
	if what == "bothand":
		get_node("mesh/Animleg").play("bothand")
	if what == "holdgun":
		get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/gun").visible = true
		get_node("mesh/Animleg").play("holdgun")
	if what == "shootgun":
		get_node("mesh/gun").play("shoot")
	if what == "die":
		get_node("mesh/Animleg").play("die")
	if what == "onknees":
		get_node("mesh/Animleg").play("onknees")
	if what == "sit":
		get_node("mesh/Animleg").play("sitonchair")
		
		
		
func _process(delta):
	if(needprocess == 1):
		if(die == 1 ):
			add_collision_exception_with(player)
			if( get_node("mesh/AnimationPlayer").is_playing() == false):
				get_parent().npcnear -= 1
				queue_free()
		else :
			if(target_pos == null):
				_findwheretogo()
				if(get_node("npc/RayCast").get_collider() != null):
					target_pos = get_node("npc/RayCast").get_collision_point()
					move_vec = target_pos - global_transform.origin
					look_at(target_pos,Vector3.UP)
					rotation_degrees.y +=180
				return
			else:
				get_node("npc/AnimationPlayer").stop()
				get_node("npc/RayCast").enabled = false

				move_and_slide(move_vec.normalized() * speed,Vector3.UP)

				if(is_on_wall()):
					target_pos = null
				if(get_node("GroundRay").is_colliding() == false):
					target_pos = null

