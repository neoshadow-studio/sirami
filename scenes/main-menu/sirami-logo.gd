
extends Sprite


var angle
var distance

var logo_radius = 0



func _ready( ):
	
	get_parent( ).connect( "resized", self, "_on_parent_resized" )
	_on_parent_resized( )
	
	set_process( true )




func _process( dt ):
	
	var m_pos = get_global_mouse_pos( )
	
	angle = ( get_parent( ).get_size( ) / 2 ).angle_to_point( m_pos ) + PI
	distance = ( m_pos - get_pos( ) ).length( ) - logo_radius




func _on_parent_resized( ):
	
	var scale = 0.4 * get_parent( ).get_size( ) / get_texture( ).get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	set_scale( scale )
	set_pos( get_parent( ).get_size( ) / 2 )
	
	logo_radius = get_texture( ).get_size( ).y * scale.x / 2