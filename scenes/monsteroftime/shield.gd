extends StaticBody


onready var _owner = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
func _ready():
#	set_bounce(1.0)
	add_collision_exception_with(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent())
func _bounce():
	pass
