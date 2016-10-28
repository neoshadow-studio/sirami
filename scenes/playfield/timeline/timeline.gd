
extends Sprite


var playfield

onready var progress = get_node( "../progress" )


func _ready( ):
	
	pass


func _process( dt ):
	
	var factor = playfield.get_time( ) / playfield.music.get_length( )
	
	var scale = ( playfield.get_size( ).y * factor ) / get_texture( ).get_size( ).y
	var y = playfield.get_size( ).y - get_texture( ).get_size( ).y * scale
	
	var sc = progress.get_scale( )
	sc.y = scale
	
	progress.set_scale( sc )
	progress.set_pos( Vector2( 0, y ) )


func initialize( pf ):
	
	playfield = pf
	
	playfield.connect( "resized", self, "on_playfield_resized" )
	
	on_playfield_resized( )
	set_process( true )


func on_playfield_resized( ):
	
	var scale = get_scale( )
	
	scale.y = playfield.get_size( ).y / get_texture( ).get_size( ).y
	
	set_scale( scale )
