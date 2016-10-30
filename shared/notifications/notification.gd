
extends Panel


var text = "Notification test"

var duration = 4

var dismissed = false




func _ready():
	
	get_node( "text" ).set_text( text )
	
	var height = get_node( "text" ).get_size( ).y + 16
	set_size( Vector2( 256, height ) )
	
	if duration > 0:
		
		get_node( "timer" ).set_wait_time( duration )
		get_node( "timer" ).start( )
	
	
	set_process_input( true )




func _input( ev ):
	
	if ev.is_action_pressed( "click" ):
		
		var m_pos = get_local_mouse_pos( )
		
		if get_rect( ).has_point( m_pos ):
			
			dismiss( )




func dismiss( ):
	
	if dismissed:
		return
	
	dismissed = true
	
	get_node( "timer" ).stop( )
	get_node( "anim" ).play( "fadeout" )


func _on_anim_finished():
	
	if dismissed:
		
		queue_free( )
		get_parent( ).remove_child( self )


func _on_timer_timeout():

	dismiss( )
