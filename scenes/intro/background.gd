
extends Sprite


func _ready():
	
	get_parent( ).connect( "resized", self, "_on_parent_resized" )
	_on_parent_resized( )



func _on_parent_resized( ):

	var scale = get_parent( ).get_size( ) / get_texture( ).get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	
	set_scale( scale )
	set_pos( get_parent( ).get_size( ) / 2 )