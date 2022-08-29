extends KinematicBody

# Can't fly below this speed
var min_flight_speed = 1.0
# Maximum airspeed
var max_flight_speed = 15

# Turn rate
var turn_speed = 0.75
# Climb/dive rate
var pitch_speed = 0.5
# Lerp speed returning wings to level
var level_speed = 5.0
# Throttle change speed
var throttle_delta = 20
# Acceleration/deceleration
var acceleration = 3.0

# Current speed
var forward_speed = 0
# Throttle input speed
var target_speed = 0
# Lets us change behavior when grounded
var grounded = true

var velocity = Vector3(0,0,0)
var turn_input = 0
var pitch_input = 0
var crashed = 0
var fuel = 2000.0
var fuelmax = 2000.0
var shooting = 0
var rockets = 10
var dirpad = Vector2()
onready var _mesh = get_node("Mesh")
var rocket
var gameend = 0
func _ready():
	rocket = preload("res://scenes/pilotwings/rocket.tscn")
	set_physics_process(false)
	set_process(false)
	
	

func _shoot():
	
	if(get_node("Mesh/MeshInstance/RayCast").is_colliding() == true and shooting == 0):
		var _rocket = rocket.instance()
		var rockspeed = (global_transform.origin  - get_node("Mesh/MeshInstance/RayCast").get_collision_point()  ).normalized() 
		_rocket.set_linear_velocity(rockspeed * -15.0)
		get_parent().add_child(_rocket)
		#_rocket.set_linear_velocity((self.get_global_transform().basis[2].normalized()) * - 20)
		_rocket.global_transform.origin = get_node("Position3D").global_transform.origin
		#_rocket.global_transform.origin.y += 0.1
		_rocket.look_at(get_node("Mesh/MeshInstance/RayCast").get_collision_point(), Vector3.UP)
		shooting = 1
		get_node("Timershoot").start()
		#_rocket.set_linear_velocity(_rocket.get_linear_velocity() + self.velocity)




func _physics_process(delta):
		dirpad = Vector2(Input.get_joy_axis(0,JOY_ANALOG_LX),Input.get_joy_axis(0,JOY_ANALOG_LY) )
		if(abs(dirpad.x) + abs(dirpad.y) < 0.5):
			dirpad = Vector2.ZERO
	
		if((get_node("Control/up").is_pressed() == true or Input.is_action_pressed("Abutton") == true)  and fuel > 0):
			target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
			fuel -= 1
		if(get_node("Control/down").is_pressed() == true or Input.is_action_pressed("Xbutton") == true):
			var limit = 0 if grounded else min_flight_speed
			target_speed = max(forward_speed - throttle_delta * delta * 3, limit)
			
		if(get_node("Control/shoot").is_pressed() == true or Input.is_action_pressed("ctrl")  or Input.is_action_pressed("Bbutton")):
			if( get_parent()._mode == "targets"):
				_shoot()


		# Turn (roll/yaw) input
		turn_input = 0
		if forward_speed > 0.5:
			turn_input -= Input.get_action_strength("ui_right")
			turn_input += Input.get_action_strength("ui_left")
			
			
			turn_input -= dirpad.x
			
		# Pitch (climb/dive) input
		pitch_input = 0
		if not grounded: # if not on ground, can go down
			pitch_input -= Input.get_action_strength("ui_up")
			pitch_input += dirpad.y * 0.5
		if (forward_speed >= 3.0):
			pitch_input += Input.get_action_strength("ui_down")
			pitch_input += dirpad.y * 0.5


		transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)# Rotate  based on the input values
		transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
		rotation_degrees.x = clamp(rotation_degrees.x, -45 , 45)
		
		
		
		if(is_on_wall()):
			_explode()
			set_physics_process(false)
			gameend = 1
			return



		# Accelerate/decelerate

		target_speed = target_speed +  target_speed * (_mesh.rotation_degrees.z / 10000)
		forward_speed = lerp(forward_speed, target_speed, acceleration * delta)
		forward_speed = min(forward_speed, 25.0)
		velocity = -transform.basis.z * forward_speed# Movement is always forward


		# Handle landing/taking off
		if is_on_floor():
			if not grounded:
				if(fuel <= 0 or abs(_mesh.rotation_degrees.z) > 15 or forward_speed > 5):
					_explode()
					set_physics_process(false)
					gameend = 1
					return
				rotation.x = 0
				rotation.z = 0
			grounded = true
		else:
			grounded = false


		var gravity =  2.0 - (forward_speed * 3 * delta )
		gravity = max(gravity, 1.0)
		velocity.y -= gravity

		velocity = move_and_slide(velocity,Vector3.UP)


		if grounded:# If on the ground, don't roll the body
			_mesh.rotation.x = 0
			_mesh.rotation.z = 0
		else:# Roll the body based on the turn input
			_mesh.rotation.x = lerp(_mesh.rotation.x, turn_input * 0.8, level_speed * delta)
			_mesh.rotation.z = lerp(_mesh.rotation.z, pitch_input * -0.8, level_speed * delta)



func _process(delta):
	
	if( gameend == 0):
		# Throttle input
		get_node("AnimationPlayer").playback_speed = forward_speed * 3
		get_node("speed/bar").scale.x = forward_speed / 25
		get_node("fuel/bar").scale.x = fuel / fuelmax
		if(Input.is_action_just_pressed("Ybutton")):
			get_parent()._changecam()
		if(get_node("Mesh/MeshInstance/RayCast").is_colliding() == true):
			if(get_parent()._cammode == 1):
				get_node("pointer").position = get_node("SpringArm/Camera").unproject_position( get_node("Mesh/MeshInstance/RayCast").get_collision_point())
			if(get_parent()._cammode == 2):
				get_node("pointer").position = get_node("Mesh/MeshInstance/Camera").unproject_position( get_node("Mesh/MeshInstance/RayCast").get_collision_point())
	else:
		get_node("SpringArm").rotation_degrees.y +=0.5
		get_node("SpringArm").rotation_degrees.x = -30
		get_node("SpringArm").rotation_degrees.z = 0
		get_node("SpringArm/Camera").current = true
		get_node("SpringArm").spring_length +=0.01

func _player():
	pass


func _win():
	gameend = 1
	set_physics_process(false)
	get_node("Button").rect_position = Vector2(64,495)
	get_node("restart").rect_position = Vector2(580,495)
	get_node("congrat").visible = true
	get_node("congrat/AnimationPlayer").play("New Anim")
	get_node("congrat/time").set_text("Your time :  " + str(floor(get_parent().gametime/60)) +":" + str(floor(fmod(get_parent().gametime,60))))
	if(floor(get_parent().gametime/60) < 2) :
		if(Global.pilotswins.modeselected == "rings"):
			if(Global.pilotswins.levelselected == 1):
				Global.pilotswins.trophies[0] = 1
			if(Global.pilotswins.levelselected == 2):
				Global.pilotswins.trophies[1] = 1
			if(Global.pilotswins.levelselected == 3):
				Global.pilotswins.trophies[2] = 1
		if(Global.pilotswins.modeselected == "targets"):
			if(Global.pilotswins.levelselected == 1):
				Global.pilotswins.trophies[3] = 1
			if(Global.pilotswins.levelselected == 2):
				Global.pilotswins.trophies[4] = 1
			if(Global.pilotswins.levelselected == 3):
				Global.pilotswins.trophies[5] = 1


func _explode():
	get_node("Animexplode").play("explode")
	crashed = 1
	gameend = 1
	get_node("Button").rect_position = Vector2(64,495)
	get_node("restart").rect_position = Vector2(580,495)
	get_parent().get_node("menu").visible = false
	get_node("speed").visible = false
	get_node("fuel").visible = false
	get_node("Control").visible = false


	if(get_parent()._mode == "rings"):
		if(get_parent().name == "pilotwings1"):
				if(get_parent().rings > Global.pilotswins.scorerings[1]):
					Global.pilotswins.scorerings[1] = get_parent().rings
					get_node("Button/Label").visible = true
					get_node("Button/Label/AnimationPlayer").play("New Anim")
		if(get_parent().name == "pilotwings2"):
				if(get_parent().rings > Global.pilotswins.scorerings[2]):
					Global.pilotswins.scorerings[2] = get_parent().rings
					get_node("Button/Label").visible = true
					get_node("Button/Label/AnimationPlayer").play("New Anim")
		if(get_parent().name == "pilotwings3"):
				if(get_parent().rings > Global.pilotswins.scorerings[3]):
					Global.pilotswins.scorerings[3] = get_parent().rings
					get_node("Button/Label").visible = true
					get_node("Button/Label/AnimationPlayer").play("New Anim")



	if(get_parent()._mode == "targets"):
		if(get_parent().name == "pilotwings1"):
				if(get_parent().targets > Global.pilotswins.scoretargets[1]):
					Global.pilotswins.scoretargets[1] = get_parent().targets
					get_node("Button/Label").visible = true
					get_node("Button/Label/AnimationPlayer").play("New Anim")
		if(get_parent().name == "pilotwings2"):
				if(get_parent().targets > Global.pilotswins.scoretargets[2]):
					Global.pilotswins.scoretargets[2] = get_parent().targets
					get_node("Button/Label").visible = true
					get_node("Button/Label/AnimationPlayer").play("New Anim")
		if(get_parent().name == "pilotwings3"):
				if(get_parent().targets > Global.pilotswins.scoretargets[3]):
					Global.pilotswins.scoretargets[3] = get_parent().targets
					get_node("Button/Label").visible = true
					get_node("Button/Label/AnimationPlayer").play("New Anim")
	Global._savegame()


func _on_Button_pressed():
				get_tree().change_scene("res://scenes/pilotwings/pilotwingsmenu.tscn")




func _on_Timershoot_timeout():
	shooting = 0


func _on_restart_pressed():
	get_tree().reload_current_scene()
