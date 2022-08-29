extends KinematicBody




onready var humanmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/head"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handr"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handl"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/hips")]
onready var skelmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/headskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlskel"),get_node("mesh/Armature/Bone/Bone001/chestskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrskel"),get_node("mesh/Armature/Bone/Bone009/ulegrskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglskel"),get_node("mesh/Armature/Bone/Bone012/uleglskel"),get_node("mesh/Armature/Bone/hipsskel")]
var clothlist #only if custom  cloth
var pdist = "toofar"
var _player
var speed = 2.0
onready var _animleg = get_node("mesh/leg")
onready var Animarm = get_node("mesh/arm")
export var humskel = ""
export var switch = ""
var state = "idle"
var pause = 0
export var spleeping = "no"
export var _type = ""

func _pause():
	pause = 1
	set_process(false)

func _unpause():
	pause = 0
	set_process(true)

func _ready():
#	_animleg.play("Idle")
	if(switch !=""):
		if(Global.mot.switch.find(switch) != -1):
			queue_free()
		
	set_process(false)
	_player = get_tree().current_scene.find_node("Kinemonster")
	if(humskel == ""):		#if human or skeleton, delete the unused meshes 
			add_to_group("npc")
			for i in skelmeshes:
				i.queue_free()
	if(humskel == "skel"):
			add_to_group("enemies")
			for i in humanmeshes:
				i.queue_free()
			
	Animarm.playback_speed = 0.8
	
	if(_type != ""): #only for human
		clothlist =[get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/hips")]
		var clothmat
		var facemat
		var hairmat
		if(_type == "friend1"):
			clothmat = load("res://scenes/monsteroftime/clothleather.tres")
			facemat = load("res://scenes/gta/npc/faceM1.tres")
			hairmat = load("res://asset/materials/hairbrown.tres")
		if(_type == "friend2"):
			clothmat = load("res://scenes/monsteroftime/clothleather.tres")
			facemat = load("res://scenes/gta/npc/faceM2.tres")
			hairmat = load("res://asset/materials/hairblond.tres")
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/bow").visible = true
			
		if(_type == "chief"):
			clothmat = load("res://scenes/monsteroftime/clothmetal.tres")
			facemat = load("res://scenes/gta/npc/faceM5.tres")
			hairmat = load("res://asset/materials/hairbrown.tres")
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").scale *= 1.5
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword/mesh").set_surface_material(1, load("res://asset/materials/hairblond.tres"))


		if(_type == "grindri"):
			clothmat = load("res://scenes/monsteroftime/clothnpc1.tres")
			facemat = load("res://scenes/gta/npc/faceM6.tres")
			hairmat = load("res://asset/materials/hairbrown.tres")
			get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/sword").visible = false
			get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/shield").visible = false



		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(0,hairmat)
		get_node("mesh/Armature/Bone/Bone001/Bone002/head").set_surface_material(1,facemat)
		for i in clothlist:
			i.set_surface_material(0,clothmat)
	
	
func _process(delta):
		if(state != "dead"):
			if(pdist == "far"):
				look_at(_player.global_transform.origin,Vector3.UP)
				Animarm.stop()
				_animleg.play("Walk")
				var movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
				movevec.y -=1
				move_and_slide(movevec * speed)
			if(pdist == "close"):
				if(Animarm.is_playing() != true):
					look_at(_player.global_transform.origin,Vector3.UP)
					if(Animarm.current_animation != "sword"):
						Animarm.play("Idleleftarm")
						Animarm.queue("sword")
					var movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
					movevec.y -=1
					move_and_slide(movevec * speed)
				else:
					var movevec = -transform.basis.z # Movement forward
					movevec.y -=1
					move_and_slide(movevec * speed * 1.5)
			if(pdist == "tooclose"):
				if(Animarm.current_animation != "sword"):
					look_at(_player.global_transform.origin,Vector3.UP)
					Animarm.play("shield")
					var movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
					movevec.y +=1
					move_and_slide(movevec * - (speed ))

func _action():
	if(_player.mode == "talking"):
		_player._talk("stop")
	else:
		look_at(_player.global_transform.origin,Vector3.UP)
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		_player._talk(_type)# add switch detetction


func _talkicon():
	pass

func _targetable():
	pass

func _shooted(amount):
	get_node("mesh/leg").play("fall")

func _sworded():
#	get_node("mesh/leg").play("die")
#	state = "dead"
#	_die()
	get_node("mesh/leg").play("fall")

func _die():
	if(switch != ""):
		_player._playsound("findobject")
		Global.mot.switch.append(switch)
		get_tree().call_group(switch,"switchreaction")


func _on_tooclose_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		_player.closeobject = self
		_player._updatehud()

func _on_tooclose_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		_player.closeobject = null
		_player._updatehud()


func _playanim(what):
	if(what == "walk"):
		_animleg.play("Walk")
	if(what == "idle"):
		_animleg.play("Idleanimated")
		
		
	if(what == "wake"):
		_animleg.play("wake",-1,0.2)
	if(what == "mouth"):
		get_node("mesh/gun").play("talk")
	if(what == "fall"):
		_animleg.play("fall")
	if(what == "wakespeed"):
		_animleg.play("wake")
	if(what == "sword"):
		_animleg.play("sword")
	if(what == "hide"):
		_animleg.play("hide")
		
func _starttext(what):
	pass
