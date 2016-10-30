
extends Sprite



onready var scene_switcher = get_node( "/root/scene_switcher" )


var playfield


func _ready():
	pass



func initialize( pf ):
	
	playfield = pf
	
	var bg = scene_switcher.get_transition_background( )
	
	if bg != null:
		
		set_texture( bg )
		
		get_parent( ).connect( "resized", self, "on_playfield_resized" )
		on_playfield_resized( )



func on_playfield_resized( ):
	
	var scale = playfield.get_size( ) / get_texture( ).get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	set_scale( scale )
	set_pos( playfield.get_size( ) / 2 )
