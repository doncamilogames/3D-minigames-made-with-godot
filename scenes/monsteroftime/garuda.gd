extends Spatial

onready var _anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _playanim(what):
	if(what == "punch"):
		_anim.play("punch")
	if(what == "idle"):
		_anim.play("Idle")
	if(what == "start"):
		_anim.play("start fligh")
	if(what == "end"):
		_anim.play("end fligh")
		
	if(what == "kick"):
		_anim.play("kick")
	if(what == "pray"):
		_anim.play("pray")
