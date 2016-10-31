### @class Part_Time
###
### @brief Holds and contains every time-related functions of the playfield.
###



extends Reference




### @brief The playfield.
var playfield

### @brief The time offset.
var offset = 0.4




### @brief Initialize a new instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf




### @brief Get the actual instant of the music.
###
### @return The time of the music.
###
func get_time( ):
	
	return playfield.clocks.get_time( "music" )
