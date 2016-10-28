
extends Sprite


var playfield


func _ready():
	pass



func initialize( pf ):
	
	playfield = pf
	
	if pf.track.files.background != "":
		
		set_texture( load( pf.track.base_dir + "/" + pf.track.files.background ) )
		
		pf.connect( "resized", self, "on_playfield_resized" )
		on_playfield_resized( )


func on_playfield_resized( ):
	
	var scale = playfield.get_size( ) / get_texture( ).get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	set_scale( scale )
	set_pos( playfield.get_size( ) / 2 )
