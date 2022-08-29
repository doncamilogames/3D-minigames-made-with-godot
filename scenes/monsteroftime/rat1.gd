extends KinematicBody

var state = "" #flee, dying
var list = []
var movevec
var speed = 7.0
var _player
func _ready():
	_player = get_tree().current_scene.find_node("Kinemonster")
#	get_node("Area/CollisionShape").add_collision_exception_with(self)
	set_process(false)

func _process(delta):
	if (state != "dead"):
		if(list.size() > 0):
			movevec =( global_transform.origin - list[0].global_transform.origin).normalized()
			movevec.y -=1
			look_at(list[0].global_transform.origin,Vector3.UP)
			rotation_degrees.x = 0
			rotation_degrees.z = 0
			get_node("AnimationPlayer").play("move")
			move_and_slide(movevec * speed,Vector3.UP)
		else:
			get_node("AnimationPlayer").queue("Idle")
			set_process(false)

func _die():
	get_node("sound").set_stream(load("res://asset/sounds/monsterhit2.wav"))
	get_node("sound").play()
	
	if(_player.targetchoice == self):
		_player.targetchoice = null
	set_process(false)
	state = "dead"

func _targetable():
	pass

func _shooted(amount):
	if (state != "dead"):
		get_node("AnimationPlayer").play("Die")
		_die()


func _sworded():
	if (state != "dead"):
		get_node("AnimationPlayer").play("Die")
		_die()


func _on_Area_body_entered(body):
	if (state != "dead"):
		list.append(body)
		if(list.size() > 0):
			set_process(true)

func _on_Area_body_exited(body):
	if (state != "dead"):
		list.erase(body)
		if(list.size() == 0):
			set_process(false)
			get_node("AnimationPlayer").queue("Idle")
