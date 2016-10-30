
extends CanvasLayer

const Notification = preload( "notification.tscn" )




func _ready():

	pass




func spawn_basic( text, duration = 2 ):
	
	var ins = Notification.instance( )
	
	ins.text = text
	ins.duration = duration
	
	get_node( "box" ).add_child( ins )
	return ins

