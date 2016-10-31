### @class Auto
###
### @brief Auto mod.


extends Reference




### @brief The playfield
var playfield

### @brief The next note which will be played
var note = null
### @brief The last time when the cursor stopped
var last_time = 0
### @brief The last pos where the cursor stopped
var last_pos = 0.5




### @brief Initialize a new instance;
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf




### @brief Update the auto mod.
###
### @param dt : The delta-time.
###
func process( dt ):
	
	# We get the first alive note
	var first = playfield.notes.get_first_alive( )
	
	# If there are no alive note
	if first == null:
		
		# We keep the current time and pos of the cursor.
		last_time = playfield.time.get_time( )
		last_pos = playfield.logical.cursor_position
		# And stop here
		return
	
	
	# If the first note is the saved note
	if first == note:
		# We update the cursor position.
		_update_cursor_position( )
	
	# Otherwise
	else:
		
		# We update the last time and last pos
		last_time = playfield.time.get_time( )
		last_pos = playfield.logical.cursor_position
		
		# Set the save node to the first alive note
		note = first
	
	# If the note can be played
	if playfield.time.get_time( ) > first.time:
		
		# We play the note
		first.play( true )
		# And remove the reference
		note = null




### @brief Update the cursor position.
###
func _update_cursor_position( ):
	
	# We get the time factor from 0 to 1
	var time_factor = ( playfield.time.get_time( ) - last_time ) / ( note.time - last_time )
	# We get the progress factor with a circ easing function.
	var progress_factor = ease( time_factor, 0.25 )
	
	# We compute the new Y position.
	var y = last_pos + (note.y_pos - last_pos) * progress_factor
	
	# And we set the cursor Y position.
	playfield.logical.set_cursor_pos( y )
