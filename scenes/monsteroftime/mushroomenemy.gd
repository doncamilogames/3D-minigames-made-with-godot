extends KinematicBody
onready var rng = RandomNumberGenerator.new()
var dirfav
var pdist = "toofar"
var _player
var speed = 3.0
onready var _anim = get_node("mesh/AnimationPlayer")
var bullet
var isshooting = 0
var hidden = 0
var _mode = ""
var pause = 0
func _ready():
	add_to_group("enemies")
	set_process(false)
	_player = get_tree().current_scene.find_node("Kinemonster")
	bullet = preload("res://scenes/monsteroftime/fireball.tscn")
	dirfav = rng.randi_range(1,2)
	if(dirfav == 1):
		_anim.play("mushIdle")
	else:
		_anim.play_backwards("mushIdle")
func _pause():
	pause = 1
	set_process(false)

func _unpause():
	pause = 0
	if(pdist == "close"):
			set_process(false)
			_anim.play("mushHide")
			_removecol()
	if(pdist == "far"):
			set_process(true)
			
	if(pdist == "toofar"):
			set_process(false)
			_anim.play("mushIdle")
			
			
func _on_Area_body_entered(body):
	if(_mode != "dead"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "far"
			set_process(true)

func _on_Area_body_exited(body):
	if(_mode != "dead"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "toofar"
			set_process(false)
			_anim.play("mushIdle")


func _on_close_body_entered(body):
	if(_mode != "dead"):
		if(body.has_method("_on_J2_pressed")):
			pdist = "close"
			set_process(false)
			_anim.play("mushHide")
			_removecol()

		
func _on_close_body_exited(body):
	if(_mode != "dead"):
			if(body.has_method("_on_J2_pressed")):
				pdist = "far"
				set_process(true)

func _removecol():
			get_node("CollisionShape").set_deferred("disabled", true)

func _targetable():
	pass

func _process(delta):
	if(_mode != "dead"):
		if(hidden == 0):
			get_node("CollisionShape").disabled = false
			look_at(_player.global_transform.origin,Vector3.UP)
			if(isshooting == 0):
				_anim.play("mushAttack")
			else:
				if(_anim.current_animation != "mushAttack"):
					if(dirfav == 1):
						_anim.play("mushIdle")
					else:
						_anim.play_backwards("mushIdle")
		else:
			_anim.play_backwards("mushHide")


func _shoot():
		get_node("AudioStreamPlayer").set_stream(load("res://asset/sounds/monster4.wav"))
		get_node("AudioStreamPlayer").play()
		var shootedbullet = bullet.instance()
		get_parent().add_child(shootedbullet)
		shootedbullet.global_transform.origin = get_node("Posbullet").global_transform.origin
		isshooting = 1
		shootedbullet._shooter = self
		shootedbullet.set_linear_velocity((self.get_global_transform().basis[2].normalized()) * - 15)
		#shootedbullet.add_collision_exception_with(self) # Add it to bullet.
		get_node("attackdelay").start()

func _on_attackdelay_timeout():
	isshooting = 0

func _hide(what):
	if(what == 0):
		hidden = 0
		return
	if(what == 1):
		hidden = 1
		return

func _shooted(amount):
	_mode = "dead"
	_anim.play("mushDie")
	get_node("AudioStreamPlayer").set_stream(load("res://asset/sounds/monster3.wav"))
	get_node("AudioStreamPlayer").play()
func _hooked():
	_mode = "dead"
	_anim.play("mushDie")
	get_node("AudioStreamPlayer").set_stream(load("res://asset/sounds/monster3.wav"))
	get_node("AudioStreamPlayer").play()
	
	
	
func _die():
	#if target, update player
	if(_player.targetchoice == self):
		_player.targetchoice = null
		
	queue_free()
