
extends StreamPlayer


var last_playhead = 0

var playfield


func _ready():
	pass


func initialize( pf ):
	
	playfield = pf
	
	set_fixed_process( true )



func _fixed_process( dt ):
	
	if get_pos( ) != last_playhead:
		
		playfield.set_time( ( playfield.get_time( ) + get_pos( ) ) / 2 )
		last_playhead = get_pos( )