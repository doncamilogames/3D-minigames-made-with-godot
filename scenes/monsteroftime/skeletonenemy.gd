extends KinematicBody


onready var humanmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/head"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handr"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmr"),get_node("mesh/Armature/Bone/Bone001/Bone003/armr"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handl"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farml"),get_node("mesh/Armature/Bone/Bone001/Bone006/arml"),get_node("mesh/Armature/Bone/Bone001/chest"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footr"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegr"),get_node("mesh/Armature/Bone/Bone009/ulegr"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footl"),get_node("mesh/Armature/Bone/Bone012/Bone013/blegl"),get_node("mesh/Armature/Bone/Bone012/ulegl"),get_node("mesh/Armature/Bone/hips")]
onready var skelmeshes = [get_node("mesh/Armature/Bone/Bone001/Bone002/headskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/Bone005/handrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/Bone004/farmrskel"),get_node("mesh/Armature/Bone/Bone001/Bone003/armrskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/Bone008/handlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/Bone007/farmlskel"),get_node("mesh/Armature/Bone/Bone001/Bone006/armlskel"),get_node("mesh/Armature/Bone/Bone001/chestskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/Bone011/footrskel"),get_node("mesh/Armature/Bone/Bone009/Bone010/blegrskel"),get_node("mesh/Armature/Bone/Bone009/ulegrskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/Bone014/footlskel"),get_node("mesh/Armature/Bone/Bone012/Bone013/bleglskel"),get_node("mesh/Armature/Bone/Bone012/uleglskel"),get_node("mesh/Armature/Bone/hipsskel")]
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
var life = 2

var movevec
func _pause():
	pause = 1
	set_process(false)

func _unpause():
	pause = 0
	set_process(true)


func _ready():
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


func _process(delta):

		if(state != "dead" and state != "falling"):
			if(pdist == "far"):
				look_at(_player.global_transform.origin,Vector3.UP)
				_animleg.play("Walk")
				Animarm.play("shield")
				movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
				movevec.y -=1
				move_and_slide(movevec * speed)
			if(pdist == "close"):
				if(Animarm.is_playing() != true):
					look_at(_player.global_transform.origin,Vector3.UP)
					rotation_degrees.x = 0
					rotation_degrees.z = 0
					if(Animarm.current_animation != "sword"):
						Animarm.play("sword")
	#					Animarm.queue("sword")
					movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
					movevec.y -=1
					move_and_slide(movevec * speed)
				else:
					movevec = -transform.basis.z # Movement forward
					movevec.y -=1
					move_and_slide(movevec * speed * 1.5)
			if(pdist == "tooclose"):
				if(Animarm.current_animation != "sword"):
					look_at(_player.global_transform.origin,Vector3.UP)
					rotation_degrees.x = 0
					rotation_degrees.z = 0
					Animarm.play("shield")
				#	Animarm.queue("sword")
				movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
				movevec.y +=1
				move_and_slide(movevec * - (speed ))

		if(state == "falling"):

			move_and_slide(movevec *  (speed ))
			if(_animleg.get_current_animation() != "fall"):
				state = ""
func _targetable():
	pass

func _playsound(what):
	get_node("sound").set_volume_db(-3)
	get_node("sound").set_pitch_scale(1.0)
	if(what == "findobject"):
		get_node("sound").set_stream(preload("res://asset/sounds/victory1.wav"))
	if(what == "clic"):
		get_node("sound").set_stream(preload("res://asset/sounds/tac1.wav"))
	if(what == "grid"):
		get_node("sound").set_stream(preload("res://asset/sounds/object1.wav"))
	if(what == "object2"):
		get_node("sound").set_stream(preload("res://asset/sounds/object2.wav"))
	if(what == "error"):
		get_node("sound").set_stream(preload("res://asset/sounds/error.wav"))
	if(what == "dooropen"):
		get_node("sound").set_volume_db(-12)
		get_node("sound").set_stream(preload("res://asset/sounds/door1.wav"))
	if(what == "doorclose"):
		get_node("sound").set_volume_db(-12)
		get_node("sound").set_stream(preload("res://asset/sounds/doorclose.wav"))
	if(what == "hitted"):
		get_node("sound").set_stream(preload("res://asset/sounds/hitted.wav"))
	if(what == "sword"):
		get_node("sound").set_pitch_scale(0.7)
		get_node("sound").set_stream(preload("res://asset/sounds/sword.wav"))
	if(what == "shield"):
		get_node("sound").set_stream(preload("res://asset/sounds/swordshield.wav"))
	if(what == "bow"):
		get_node("sound").set_stream(preload("res://asset/sounds/arrowshot.wav"))
		
	get_node("sound").play()


func _swordattack():
	_playsound("sword")


func _shooted(amount):
	if(state != "dead"):
		if(Animarm.current_animation != "shield"):

			get_node("mesh/leg").play("fall")
			get_node("mesh/leg").queue("Idle")
			state = "falling"
			movevec = transform.basis.z * 2
			life -= 1
			if(life <= 0):
				dying()



func dying():
	if(state != "dead"):
		get_node("mesh/leg").play("die")
		if(switch != ""):
			_player._playsound("findobject")
			Global.mot.switch.append(switch)
			get_tree().call_group(switch,"switchreaction")
		if(_player.targetchoice == self):
			_player.targetchoice = null
		get_node("CollisionShape").disabled = true
		remove_from_group("enemies")
		state = "dead"

func _sworded():
	if(state != "dead"):
		if(Animarm.current_animation != "shield"):
			get_node("mesh/leg").play("fall")
			state = "falling"
			movevec = transform.basis.z * 2
			life -= 1
			if(life <= 0):
				dying()


func _on_far_body_entered(body):
	if(body.has_method("_on_J2_pressed") and pause == 0):
		pdist = "far"
		set_process(true)


func _on_far_body_exited(body):
	if(body.has_method("_on_J2_pressed") and pause == 0):
		pdist = "toofar"
		set_process(false)
		_animleg.play("Idle")
#		state = "idle"


func _on_close_body_entered(body):
	if(body.has_method("_on_J2_pressed") and pause == 0):
		pdist = "close"
		set_process(true)


func _on_close_body_exited(body):
	if(body.has_method("_on_J2_pressed") and pause == 0):
		pdist = "far"
		set_process(true)


func _on_tooclose_body_entered(body):
	if(body.has_method("_on_J2_pressed") and pause == 0):
		pdist = "tooclose"
		set_process(true)

func _on_tooclose_body_exited(body):
	if(body.has_method("_on_J2_pressed") and pause == 0):
		#pdist = "close"
		set_process(true)
