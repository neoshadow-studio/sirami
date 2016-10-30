
extends Sprite


onready var scene_switcher = get_node( "/root/scene_switcher" )


func _ready():
	
	var bg = scene_switcher.get_transition_background( )
	
	if bg != null:
		
		set_texture( bg )
		
		get_parent( ).connect( "resized", self, "on_resized" )
		on_resized( )




func on_resized( ):
	
	var scale = get_parent( ).get_size( ) / get_texture( ).get_size( )
	
	if scale.x < scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	set_scale( scale )
	set_pos( get_parent( ).get_size( ) / 2 )

