
extends Sprite


export(float, 0, 1, 0.05) var factor = 0 setget set_factor, get_factor




func _ready():

	pass




func set_factor( v ):
	
	factor = v
	
	var tex = get_texture()
	var width = tex.get_width() * factor
	var height = tex.get_height()
	
	var rect = Rect2(0, 0, width, height)
	set_region_rect(rect)


func get_factor( ):
	
	return factor