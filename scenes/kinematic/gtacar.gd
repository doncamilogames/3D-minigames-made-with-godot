extends KinematicBody
onready var player = get_tree().current_scene.find_node("Kinemacron")
onready var rng = RandomNumberGenerator.new()
var color
var speedmax = 10.0
var speed = 10.0
var _material 
var _owner = "npc"
var life = 300.0
var lifemax = 300.0
var broke = 0
var directionfav
var target_pos
var move_vec
var wheretolook
var fromwhere
var turnspeed = 0.5
var targetyrot = 0
var windowsparts = []
var metalparts = []
var nearchest = 0
export var _specialcar = ""
var typeofcar
onready var brokenbodymat  = load("res://asset/mesh/gta/carmetalbroke.tres")
onready var brokenwindowmat  = load("res://asset/mesh/gta/carwindowbrok.tres")
func _ready():
	if(get_parent().name != "GTATown"):
		set_process(false)
	
	if(_specialcar == "" or "cousin" in _specialcar):
		windowsparts = [[get_node("Mesh/all"),0],[get_node("Mesh/door1/door1"),1],[get_node("Mesh/door2/door2"),1],[get_node("Mesh/door3/door3"),0],[get_node("Mesh/door4/door4"),0],[get_node("Mesh/chest/chest"),0]]
		metalparts = [[get_node("Mesh/all"),1],[get_node("Mesh/door1/door1"),0],[get_node("Mesh/door2/door2"),0],[get_node("Mesh/door3/door3"),1],[get_node("Mesh/door4/door4"),1],[get_node("Mesh/chest/chest"),1]]

	rng.randomize()
	_change_color()
	brokenbodymat = brokenbodymat.duplicate()
	brokenwindowmat = brokenwindowmat.duplicate()
	directionfav = rng.randi_range(1,2)

	
func _process(delta):
	if(global_transform.origin.distance_to(player.global_transform.origin) > 40):
		get_parent().carnear -= 1
		queue_free()
	if(_owner == "npc" ):
		if(broke == 0):
			if(target_pos == null):
				speed = 4.0
				if(directionfav == 1):
					rotation_degrees.y += 6.0
				else:
					rotation_degrees.y -= 6.0
			#	if(abs(rotation_degrees.y) >= 360):
			#		rotation_degrees.y = 0
				if(get_node("npc/RayCast").get_collider() != null):
					target_pos = get_node("npc/RayCast").get_collision_point()
					#move_vec = target_pos - global_transform.origin
					#look_at(target_pos,Vector3.UP)
				#	wheretolook = global_transform.looking_at(target_pos, Vector3.UP)
				#	fromwhere = self.global_transform
				return
			else:
	#			global_transform.basis.y = lerp(fromwhere.basis.y, wheretolook.basis.y, turnspeed)
	#			global_transform.basis.x = lerp(fromwhere.basis.x, wheretolook.basis.x, turnspeed)
	#			global_transform.basis.z = lerp(fromwhere.basis.z, wheretolook.basis.z, turnspeed)
	#			scale = Vector3(1,1,1)
				speed = lerp(speed, speedmax,  delta  ) 
				move_vec = -transform.basis.z * speed# Movement is always forward
				#move_and_slide(move_vec.normalized() * speed,Vector3.UP)
				move_and_slide(move_vec,Vector3.UP)
			if(is_on_wall()):
					target_pos = null
			if(get_node("GroundRay").is_colliding() == false):
					target_pos = null

func _change_color():
	if(_specialcar == ""):
		_material = load("res://asset/mesh/gta/gtacar2metal.tres")
		_material = _material.duplicate()
		rng.randomize()
		color = rng.randi_range(1,4)
		if(color == 0):#white
			color = "ffffff"
		elif(color == 1):#red
			color = "ff0000"
		elif(color == 2):#green
			color = "5cff00"
		elif(color == 3):#blue
			color = "0081ff"
		elif(color == 4):#yellow
			color = "ffc500"
		elif(color == 5):#black
			color = "3a1f42"
		for i in metalparts:
			i[0].set_surface_material(i[1],_material)
			i[0].get_surface_material(i[1]).set_albedo(color)
	else:
		var hjghdkhgkjdh = get_parent().missionscars.get(typeofcar)[1]
		_material = load(hjghdkhgkjdh)
		_material = _material.duplicate()
		for i in metalparts:
			i[0].set_surface_material(i[1],_material)


func _car():
	pass

func _damagecar(amount):

	if(broke == 0):
		life -= amount
		if(life / lifemax < .5):
			if(get_node("smoke").is_emitting() == false):
				get_node("smoke").set_emitting(true)
			get_node("smoke").set_amount(ceil(5 - 5* (life / lifemax)))
	#	get_node("AudioStreamPlayer3D").play(0.7)
		if(life < 0):
			life = 0
			broke = 1
			get_node("eplodewhenbroke").start()


func _on_Area_body_entered(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "startcar" and body.mode != "stopcar"):
				get_parent().closeobject = self
				get_parent()._closeobject("car")


func _on_Area_body_exited(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "startcar" and body.mode != "stopcar"):
				get_parent().closeobject = null
				get_parent()._closeobject("null")

func _on_npccol_body_entered(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_cared")):
			if(_owner == "player"):
				if(player.speedtemp > 8.0):
					body._cared(player.speedtemp * 5)
					player.speedtemp -= 8.0
					_damagecar(player.speedtemp *2.5)
					if(body.has_method("_npc")):
						player._crime(1.0)
					elif(body.is_in_group("cops")):
						player._crime(2.0)
					elif(body.is_in_group("ennemy")):
						player._crime(0.5)
						
			if(_owner == "npc"):

				if(speed > 5.0):
					body._cared(speed * 2)
					_damagecar(speed *2)
					speed -= 2.0
					
	if(body.is_in_group("breakable")):
		if(_owner == "player"):
			if(player.speedtemp > 4.0):
				body.queue_free()
				player.speedtemp -= 4.0
				_damagecar(player.speedtemp )
func _cared(amount):
	_damagecar(amount)
		

func _shooted(who, strength):
	_damagecar(strength / 2.0)
		
func _punched(who):
	if(broke == 0):
		_damagecar(5.0)

func _on_eplodewhenbroke_timeout():
	get_node("Animexplode").play("explode")
	get_node("balloffire/colfire/CollisionShape").disabled = false
	get_node("sound").play()
func _explodedmaterials():
	get_node("balloffire/colfire/CollisionShape").disabled = true
	if(_specialcar == ""):
		for i in metalparts:
			i[0].set_surface_material(i[1],brokenbodymat)
			i[0].get_surface_material(i[1]).set_albedo(color)
		for i2 in windowsparts:
			i2[0].set_surface_material(i2[1],brokenwindowmat)
	else:
		for i in metalparts:
			i[0].set_surface_material(i[1],brokenbodymat)
		for i2 in windowsparts:
			i2[0].set_surface_material(i2[1],brokenwindowmat)
#	get_node("Mesh").set_surface_material(1,brokenbodymat)
#	get_node("Mesh").get_surface_material(1).set_albedo(color)
#	get_node("Mesh").set_surface_material(2,brokenwindowmat)
#	get_node("Mesh").set_surface_material(3,brokenwindowmat)


func _on_Areachest_body_entered(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "startcar" and body.mode != "stopcar"):
				get_parent().closeobject = self
				get_parent()._closeobject("carchest")
				nearchest = 1

func _on_Areachest_body_exited(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car" and body.mode != "startcar" and body.mode != "stopcar"):
				get_parent().closeobject = null
				get_parent()._closeobject("null")
				nearchest = 0


func _on_colfire_body_entered(body):
	if(body.has_method("_receivedamage")):
			body._receivedamage(200,"car")
