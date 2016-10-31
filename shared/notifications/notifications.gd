### @class Notifications
###
### @brief Simple notification system.
###



extends CanvasLayer




const Notification = preload( "notification.tscn" )




### @brief Spawns a basic notification, with a text.
###
### @param text : Text of the notification.
### @param duration : Duration of the notification (0 for no duration).
###
func spawn_basic( text, duration = 2 ):
	
	# We create a new instance
	var ins = Notification.instance( )
	
	# We set its text and duration
	ins.text = text
	ins.duration = duration
	
	# We get the box node and add the new notification.
	get_node( "box" ).add_child( ins )
	# We return the notification.
	return ins

