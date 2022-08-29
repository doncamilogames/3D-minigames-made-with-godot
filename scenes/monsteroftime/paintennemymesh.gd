extends Spatial
var _player
var state = "idle"
onready var hand = get_node("Armature/Bone001/Bone002/Pos")
func _ready():
	set_process(false)
	_player = get_tree().current_scene.find_node("Kinemonster")
	
	
func _on_hand_body_entered(body):
	if(body.has_method("_on_J2_pressed") and state == "atack"):
		get_node("AnimationPlayer").play("succes")
		state = "succes"
		get_node("AudioStreamPlayer3D").set_pitch_scale(0.7)
		get_node("AudioStreamPlayer3D").set_stream(load("res://asset/sounds/patrickeat.wav"))
		get_node("AudioStreamPlayer3D").play()
		set_process(true)

func _on_inrange_body_entered(body):
	if(body.has_method("_on_J2_pressed") and state == "idle"):
		state = "atack"
		get_node("AnimationPlayer").play("atack")
		get_node("AudioStreamPlayer3D").set_pitch_scale(0.4)
		get_node("AudioStreamPlayer3D").set_stream(load("res://asset/sounds/patrickata.wav"))
		get_node("AudioStreamPlayer3D").play()
		set_process(true)
	
func _process(delta):
	if(state == "succes"):
		if(get_node("AnimationPlayer").is_playing() == true):
			_player.global_transform.origin = hand.global_transform.origin 
			_player.rotation_degrees.y = rotation_degrees.y - 90
		else:
			_player._sworded()
			_player.velocity = _player.transform.basis.z * 100
			_player.get_node("mesh/leg").play("fall")
			_player.mode = "falling"
			get_node("AnimationPlayer").play("Idle")
			state = "idle"
			get_node("AudioStreamPlayer3D").set_pitch_scale(0.7)
			get_node("AudioStreamPlayer3D").set_stream(load("res://asset/sounds/patricklau.wav"))
			get_node("AudioStreamPlayer3D").play()
			set_process(false)
			
	if(state == "atack"):
		if(get_node("AnimationPlayer").is_playing() == false):
			get_node("AnimationPlayer").play("Idle")
			state = "idle"
			set_process(false)


func _shooted(amount):
	if(state != "dead"):
		get_node("AnimationPlayer").play("paintdie2")
		get_node("AudioStreamPlayer3D").set_stream(load("res://asset/sounds/patrickdie.wav"))
		get_node("AudioStreamPlayer3D").set_pitch_scale(0.3)
		get_node("AudioStreamPlayer3D").play()
		state = "dead"
		
func _hooked():
	if(state != "dead"):
		get_node("AnimationPlayer").play("paintdie2")
		get_node("AudioStreamPlayer3D").set_stream(load("res://asset/sounds/patrickdie.wav"))
		get_node("AudioStreamPlayer3D").set_pitch_scale(0.3)
		get_node("AudioStreamPlayer3D").play()
		state = "dead"
