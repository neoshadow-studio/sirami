
extends StreamPlayer


onready var clocks = get_node( "/root/clocks" )


var last_playhead = 0


func _ready():
	
	clocks.add_clock( "music" )
	
	set_fixed_process( true )



func reset( ):
	
	last_playhead = 0


func _fixed_process( dt ):
	
	
	if get_pos( ) != last_playhead:
		
		clocks.set_time( "music", ( clocks.get_time( "music" ) + get_pos( ) ) / 2 )
		last_playhead = get_pos( )
	