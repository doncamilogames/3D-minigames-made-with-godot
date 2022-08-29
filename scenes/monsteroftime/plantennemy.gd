extends KinematicBody
var pdist = "toofar"
var _player
var speed = 3.0
onready var _anim = get_node("AnimationPlayer")
var state = "idle"
var pause = 0
export var move = "no"
export var switch = ""

func _ready():
	if(switch !=""):
		if(Global.mot.switch.find(switch) != -1):
			queue_free()
		
	
	add_to_group("enemies")
	set_process(false)
	_player = get_tree().current_scene.find_node("Kinemonster")
func _pause():
	pause = 1
	set_process(false)
	
	
func _getshooted(amount):
	_die()
func _sworded():
	_die()

func _die():
	_anim.play("plantdie")
	get_node("sound").set_stream(load("res://asset/sounds/monsterhit3.wav"))
	get_node("sound").pitch_scale = 0.5
	get_node("sound").play()
	set_process(false)
	state = "die"
	if(_player.targetchoice == self):
		_player.targetchoice = null
	if(switch != ""):
		#_player._playsound("findobject")
		Global.mot.switch.append(switch)
		get_tree().call_group(switch,"switchreaction")

func _delete():
	get_node("AnimationPlayer").stop()
	queue_free()

func _unpause():
	pause = 0
	set_process(true)
func _on_close_body_entered(body):
	if(state != "die"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "close"
			set_process(true)


func _on_close_body_exited(body):
	if(state != "die"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "far"
			set_process(true)

func _targetable():
	pass

func _on_far_body_entered(body):
	if(state != "die"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "far"
			set_process(true)

func _attacksound():
	get_node("sound").play()

func _on_far_body_exited(body):
	if(state != "die"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "toofar"
			set_process(false)
			_anim.play("plantIdle")
			state = "idle"

func _process(delta):
	if(state != "die"):
		if(move == "no"):
			if(_anim.current_animation != "plantattackstand"):
				look_at(_player.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
				if(pdist == "far"):
					_anim.play("plantIdlenear")
				if(pdist == "close"):
					_anim.play("plantattackstand")


		else:
			if(_anim.current_animation != "plantattack"):
				look_at(_player.global_transform.origin,Vector3.UP)
				rotation_degrees.x = 0
				rotation_degrees.z = 0
				if(pdist == "far"):
					_anim.play("plantwalk")
					var movevec = (_player.global_transform.origin - global_transform.origin  ).normalized()
					movevec.y -=1
					move_and_slide(movevec * speed)
				if(pdist == "close"):
					_anim.play("plantattack")
					



func _on_shield_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		_player.velocity = _player.transform.basis.z * 70
		_player.get_node("mesh/leg").play("fall")
		_player.mode = "falling"
