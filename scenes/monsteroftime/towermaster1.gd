extends StaticBody
var life = 10.0
var shootspeed = 1.0
var turnspeed = 0.1
var bullet
var isshooting = 0
var bulletspeed = 0
onready var _canon = get_node("Spatial/canon")
var _player
export var _type = ""
func _ready():
	var _material = load("res://scenes/macronbros/tile/plane22.tres")
	_material = _material.duplicate()
	add_to_group(get_parent().name)
	_player = get_tree().current_scene.find_node("Kinemonster")

	if(_type == ""):
		life = 3.0
		shootspeed = 1.0
		turnspeed = 0.1
		bulletspeed = 10
		bullet = preload("res://scenes/roguelike/fireball.tscn")
		_material.set_albedo("ffc2c2")
	if(_type == "fast"):
		life = 10.0
		shootspeed = 0.8
		turnspeed = 0.15
		bulletspeed = 30
		bullet = preload("res://scenes/roguelike/fireball.tscn")
		_material.set_albedo("da6161")
	if(_type == "vfast"):
		life = 10.0
		shootspeed = 0.5
		turnspeed = 0.2
		bulletspeed = 40
		bullet = preload("res://scenes/roguelike/fireball.tscn")
		_material.set_albedo("eb0000")
	if(_type == "rainbow"):
		life = 10.0
		shootspeed = 0.8
		turnspeed = 0.2
		bulletspeed = 4
		bullet = preload("res://scenes/roguelike/rainball.tscn")
		_material.set_albedo("00ffcf")
	if(_type == "switch"):
		life = 10.0
		shootspeed = 1.0
		turnspeed = 0.1
		bulletspeed = 8
		bullet = preload("res://scenes/roguelike/switchbullet.tscn")
	get_node("base").set_surface_material(0,_material)
	get_node("attackdelay").wait_time = shootspeed
#	_stop()
	
	
func _process(delta):
	var T = global_transform.looking_at(_player.global_transform.origin, Vector3.UP)
	_canon.global_transform.basis.y = lerp(_canon.global_transform.basis.y, T.basis.y, turnspeed)
	_canon.global_transform.basis.x = lerp(_canon.global_transform.basis.x, T.basis.x, turnspeed)
	_canon.global_transform.basis.z = lerp(_canon.global_transform.basis.z, T.basis.z, turnspeed)
#	_canon.rotation_degrees.x = 0
#	_canon.rotation_degrees.z = 0
	_canon.scale = Vector3(1,1,1)
#	_canon.rotation_degrees.y = lerp(_canon.rotation_degrees.y, T.basis.y.normalized() ,turnspeed)
	if(isshooting == 0):
		_shoot()

func _start():
	visible = true
	set_process(true)

func _stop():
	visible = false
	set_process(false)


func _shoot():
		get_node("AudioStreamPlayer").play()
		var shootedbullet = bullet.instance()
		get_parent().add_child(shootedbullet)
		shootedbullet.global_transform.origin = get_node("Spatial/canon/Posbullet").global_transform.origin
		isshooting = 1
		shootedbullet._shooter = self
		shootedbullet.set_linear_velocity((_canon.get_global_transform().basis[2].normalized()) * - bulletspeed)
		#shootedbullet.add_collision_exception_with(self) # Add it to bullet.
		get_node("attackdelay").start()


func _shooted(amount):
	life -= amount
	if(life <= 0):
		queue_free()

func _on_attackdelay_timeout():
	isshooting = 0
