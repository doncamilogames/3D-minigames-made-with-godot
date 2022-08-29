extends KinematicBody
onready var player = get_tree().current_scene.find_node("Kinemacron")
onready var rng = RandomNumberGenerator.new()
var color
var speedmax = 10.0
var speed = 10.0
var _material 
var _owner = "npc"
var life = 500.0
var lifemax = 500.0
var broke = 0
var directionfav
var target_pos
var move_vec

export var _specialcar = ""

onready var brokenbodymat  = load("res://asset/mesh/gta/carmetalbroke.tres")
onready var brokenwindowmat  = load("res://asset/mesh/gta/carwindowbrok.tres")
var typeofcar


func _ready():






#	rng.randomize()
	_change_color()
	brokenbodymat = brokenbodymat.duplicate()
	brokenwindowmat = brokenwindowmat.duplicate()

	directionfav = rng.randi_range(1,2)
#	_findwheretogo()
	
func _findwheretogo():
#	rotation_degrees.y = 0

	if(directionfav == 1):# first direction random
		get_node("npc/AnimationPlayer").play("findtrot")
	else:
		get_node("npc/AnimationPlayer").play("findtrot2")
	#get_node("npc/RayCast").enabled = true
	
func _process(delta):
	if(global_transform.origin.distance_to(player.global_transform.origin) > 40):
		get_parent().carnear -= 1
		queue_free()
	if(_owner == "npc" ):
		if(broke == 0):
			if(target_pos == null):
				speed = 0.0
				_findwheretogo()
				if(get_node("npc/RayCast").get_collider() != null):
					target_pos = get_node("npc/RayCast").get_collision_point()
					move_vec = target_pos - global_transform.origin
					look_at(target_pos,Vector3.UP)
				return
			else:
				speed = lerp(speed, speedmax,  delta  ) 
				move_and_slide(move_vec.normalized() * speed,Vector3.UP)
				if(is_on_wall()):
					target_pos = null
				if(get_node("GroundRay").is_colliding() == false):
					target_pos = null

func _change_color():
	var hjghdkhgkjdh = get_parent().missionscars.get(typeofcar)[1]
	_material = load(hjghdkhgkjdh)
	_material = _material.duplicate()
	
	get_node("Mesh").set_surface_material(1,_material)

	
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
	print(life)

func _on_Area_body_entered(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"):
				get_parent().closeobject = self
				get_parent()._closeobject("car")


func _on_Area_body_exited(body):
	if(get_parent().name == "GTATown"):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"):
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
					speed -= 2.0
					body._cared(speed * 2)
					_damagecar(speed *2)

func _cared(amount):
		_damagecar(amount)
		

func _shooted(who, strength):
	if(broke == 0):
		_damagecar(strength)
		
func _punched(who):
	if(broke == 0):
		_damagecar(5.0)

func _on_eplodewhenbroke_timeout():
	get_node("Animexplode").play("explode")
	get_node("sound").play()
func _explodedmaterials():
	get_node("Mesh").set_surface_material(1,brokenbodymat)
	get_node("Mesh").get_surface_material(1).set_albedo(color)
	get_node("Mesh").set_surface_material(2,brokenwindowmat)
	get_node("Mesh").set_surface_material(3,brokenwindowmat)
