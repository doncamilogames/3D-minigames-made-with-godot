extends Area
var rng = RandomNumberGenerator.new()
var state = "ok"
var objgiven
func _ready():
	rng.randomize()
	
	
	
	
func _getobj():
	objgiven = null

func _sworded():
	if(state == "ok"):
		get_node("plant1").visible = false
		get_node("CPUParticles").set_emitting(true)
		get_node("Timer").start()
		state = "cuted"
		
		if(objgiven == null):
			var reward = rng.randi_range(0,10)
			if(reward <= 2):
				objgiven = preload("res://scenes/monsteroftime/smallheart.tscn")
				objgiven = objgiven.instance()
				objgiven._owner = self
				add_child(objgiven)
				#spawn hear
			if(reward > 2 and reward <= 5):
				objgiven = preload("res://scenes/monsteroftime/arrow.tscn")
				objgiven = objgiven.instance()
				objgiven._owner = self
				add_child(objgiven)
				#spawn arrow
			if(reward > 5 and reward <= 10):
				objgiven = preload("res://scenes/monsteroftime/coin.tscn")
				objgiven = objgiven.instance()
				objgiven._owner = self
				add_child(objgiven)
				#spawn coin
				
			if(objgiven != null):
				objgiven.transform.origin += Vector3(rng.randf_range(-0.5,0.5),rng.randf_range(0.2,0.5),rng.randf_range(-0.5,0.5))

func _on_Timer_timeout():
	get_node("AnimationPlayer").play("growth")

	state = "ok"
