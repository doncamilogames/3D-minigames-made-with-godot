extends Spatial

func _ready():
	pass 

func _on_G1_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "G1"
 
		body._updatehud()
func _on_G2_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "G2"
 
		body._updatehud()
func _on_G3_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "G3"
 
		body._updatehud()
func _on_G4_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "G4"
 
		body._updatehud()


func _on_Y1_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "Y1"
 
		body._updatehud()
func _on_Y2_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "Y2"
 
		body._updatehud()
func _on_Y3_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "Y3"
 
		body._updatehud()
func _on_Y4_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "Y4"
 
		body._updatehud()


func _on_B1_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "B1"
 
		body._updatehud()
func _on_B2_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "B2"
 
		body._updatehud()
func _on_B3_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "B3"
 
		body._updatehud()
func _on_B4_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "B4"
 
		body._updatehud()


func _on_R1_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "R1"
 
		body._updatehud()
func _on_R2_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "R2"
 
		body._updatehud()
func _on_R3_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "R3"
 
		body._updatehud()
func _on_R4_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().currentarea = "R4"
 
		body._updatehud()
