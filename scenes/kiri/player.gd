extends RigidBody
var keyboarddir = Vector2()
var move = 0
var speedtemp = 0.0
var acceleration = 2.0
var velocity = Vector3()
var hitwall = 0
var speed = 15.0
var life = 3
var dirrot = -1
var recovering = 0
var invinsible = 0
var _dead = 0
var _finished = 0
var keys = []
var perfect = 2
var dirpad = Vector2()
func _ready():
#	get_node("Area").scale = Vector3(1,1,0.75) if easy
	Global._updateadjworldenv()
	add_collision_exception_with(get_node("Area"))

func _explode():
	get_node("Animexplode").play("explode")
	get_node("bird1").visible = true
	get_node("bird2").visible = true
	_dead = 1

func _physics_process(delta):
	dirpad = Vector2(Input.get_joy_axis(0,JOY_ANALOG_LX),Input.get_joy_axis(0,JOY_ANALOG_LY) )
	if(abs(dirpad.x) + abs(dirpad.y) < 0.8):
		dirpad = Vector2.ZERO
	get_parent().get_node("Camera").global_transform.origin = global_transform.origin
	if(_dead == 0 and _finished == 0):
		get_parent().get_node("Camera").global_transform.origin.y = 20
		keyboarddir =  Vector2(_axis().x,_axis().z)
		
		if(keyboarddir != Vector2.ZERO) :
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity.x = keyboarddir.x * speedtemp
			velocity.z = keyboarddir.y * speedtemp 

			
		elif(get_node("Control/Virtual joystick")._output != Vector2.ZERO) :
			#get_node("Control/Virtual joystick")._output.normalized().y
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity = Vector3(get_node("Control/Virtual joystick")._output.x,0,get_node("Control/Virtual joystick")._output.y) * speedtemp

		elif(get_node("Control/Virtual joystick2")._output != Vector2.ZERO) :
			#get_node("Control/Virtual joystick")._output.normalized().y
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity = Vector3(get_node("Control/Virtual joystick2")._output.x,0,get_node("Control/Virtual joystick2")._output.y) * speedtemp * 1.5

		elif(dirpad != Vector2.ZERO):#pad move
			#get_node("Control/Virtual joystick")._output.normalized().y
			speedtemp = lerp(speedtemp, speed, acceleration * delta)
			velocity = Vector3(dirpad.x,0,dirpad.y) * speedtemp 
			

		else:
			speedtemp = lerp(speedtemp, 0.0,  delta * 100) 
#			velocity.x = lerp(velocity.x,0.0,0.1)
#			velocity.z = lerp(velocity.z,0.0,0.1 )
			velocity = Vector3.ZERO
		set_linear_velocity(velocity)
		
		if(hitwall == 0):
			set_angular_velocity(Vector3(0,dirrot,0))
		else :
			if(recovering == 0):
				set_angular_velocity(Vector3(0,(-30 * dirrot),0))
				set_linear_velocity(-5 * velocity)
				get_node("AudioStreamPlayer").play()
				speedtemp = 0
				hitwall = 0
				life -= 1
				perfect -= 1

				get_parent().get_node("Hud/touched/AnimationPlayer").play("Anim")
				get_node("recover").stop()
				if(life <= 0):
					_explode()
					get_parent().get_node("Hud").get_child(life).visible = false
					pass
				else:
					get_parent().get_node("Hud").get_child(life).visible = false
				recovering = 1
				get_node("recover").start()
		if(invinsible == 1):
			life = 3
			get_parent().get_node("Hud/Sprite").visible = true
			get_parent().get_node("Hud/Sprite2").visible = true
			get_parent().get_node("Hud/Sprite3").visible = true
	else:
		if(_dead == 1 ):
			get_parent().get_node("Camera").global_transform.origin.y = 10
			if(get_node("Animexplode").is_playing() == false):
				get_tree().change_scene("res://scenes/kiri/kirimenu.tscn")
		if(_finished == 1 ):
			get_parent().get_node("Camera").global_transform.origin.y = 10
			get_node("bird1").visible = true
			get_node("bird2").visible = true
			if(get_node("Animexplode").is_playing() == false):
				if(str2var(Global.kiri.levelselected) == Global.kiri.level):
					Global.kiri.level +=1
					Global.kiri.levelselected = str(Global.kiri.level)
				Global._savegame()
				get_tree().change_scene("res://scenes/kiri/kirimenu.tscn")


		
		
func _axis():
	var direction = Vector3()
	if Input.is_action_pressed("ui_up")  == true:
		direction -= Vector3(0,0,1) #go foward
	if Input.is_action_pressed("ui_down"):
		direction += Vector3(0,0,1)
	if Input.is_action_pressed("ui_left"): 
		direction -= Vector3(1,0,0)
	if Input.is_action_pressed("ui_right"):
		direction += Vector3(1,0,0)
#	if(direction == Vector3(0,0,0)):
#		move = 0
#	else :
#		move = 1
	return direction.normalized()


func _on_player_body_entered(body):
	if(body.has_method("_bounce")):
		body._bounce()
		get_parent().get_node("Audiosound").set_stream(load("res://asset/sounds/spring.wav"))
		get_parent().get_node("Audiosound").play()
		if(recovering == 0):
			dirrot = -1 * dirrot
			recovering = 1
			get_node("recover").start()
	else:
		if(recovering == 0):
			hitwall = 1


func _on_Area_body_entered(body):
	if(body != get_parent()):
		if(body.has_method("_bounce")):
			body._bounce()
			get_parent().get_node("Audiosound").set_stream(load("res://asset/sounds/spring.wav"))
			get_parent().get_node("Audiosound").play()
			if(recovering == 0):
				dirrot = -1 * dirrot
				recovering = 1
				get_node("recover").start()
		else:
			if(recovering == 0):
				hitwall = 1



func _on_levelend_body_entered(body):
	if(body == self):
		get_node("Animexplode").play("endind")
		_finished = 1
		get_parent().get_node("Audiosound").set_stream(load("res://asset/sounds/victory1.wav"))
		get_parent().get_node("Audiosound").volume_db = 10.0
		get_parent().get_node("Audiosound").pitch_scale = 2.0
		get_parent().get_node("Audiosound").play()
		if perfect == 1 :
			var ngdfgdame = get_parent().name
			ngdfgdame.erase(0,5)
			Global.kiri.trophies[str2var(ngdfgdame) - 1] = 1
			
			
			
func _on_recover_timeout():
	recovering = 0

func _on_refill_life_body_entered(body):
	if(body == self):
		invinsible = 1
		get_parent().get_node("Audiosound").set_stream(load("res://asset/sounds/bonus1.wav"))
		get_parent().get_node("Audiosound").play()

func _on_refill_life_body_exited(body):
	if(body == self):
		invinsible = 0





func _on_key_body_entered(_key):
	keys.append(_key)
	get_tree().call_group(_key,"_open")
