extends Area

var propscene
export var props = ""
func _ready():
		if(props == "parc"):
			get_node("CollisionShape").shape.radius = 60
		if(props == "lights"):
			get_node("CollisionShape").shape.radius = 80



		

func _on_proparea_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		if(props == "pubext"):
			propscene = preload("res://scenes/gta/props/pubext.tscn")
			propscene = propscene.instance()
			self.add_child(propscene)
			for i in propscene.get_children():
		#		print(i.name)
				i.add_to_group("breakable")
		if(props == "manorext"):
			propscene = preload("res://scenes/gta/props/manorext.tscn")
			propscene = propscene.instance()
			self.add_child(propscene)
		if(props == "parc"):
			propscene = preload("res://scenes/gta/props/parc.tscn")
			propscene = propscene.instance()
			self.add_child(propscene)
		if(props == "lights"):
			propscene = preload("res://scenes/gta/props/streetlights.tscn")
			propscene = propscene.instance()
			self.add_child(propscene)
		if(props == "smallwall"):
			propscene = preload("res://scenes/gta/props/carfencesmall.tscn")
			propscene = propscene.instance()
			self.add_child(propscene)
			if(Global.gtc.Zombieswitch.find(name) == -1):
				Global.gtc.Zombieswitch.append(name)
		if(props == "bigwall"):
			propscene = preload("res://scenes/gta/props/carfencebig.tscn")
			propscene = propscene.instance()
			self.add_child(propscene)
			if(Global.gtc.Zombieswitch.find(name) == -1):
				Global.gtc.Zombieswitch.append(name)
			
			
func _on_proparea_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		if( is_instance_valid(propscene)):
			propscene.queue_free()
