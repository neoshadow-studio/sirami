### @class Part_Notes
###
### @brief Handles and manages the notes.
###



extends Reference



const BasicNote = preload( "../notes/basic_note.tscn" )




### @brief The playfield.
var playfield

### @brief The node holding the actives notes.
var notes_holder

### @brief The list of notes.
var list
### @brief The current note.
var index 



signal played( note )
signal should_be_played( note )



### @brief Initialize a new instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf
	
	# We get the notes holder note
	notes_holder = pf.get_node( "notes" )
	
	# We get the list and set the starting index
	list = pf.track.notes
	index = 0
	
	# We apply the time offset.
	for n in list:
		
		n.time += playfield.time.offset




### @brief Update the note manager.
###
### @param dt : The delta-time.
###
func fixed_process( dt ):
	
	# If we are not at the end of the list.
	if index < list.size( ):
		# We try to spawn notes.
		_try_spawn_note( )




### @brief Try to spawn some notes.
###
func _try_spawn_note( ):
	
	# We get the speed of the notes.
	# TODO: Handle speed modifier
	var speed = playfield.track.difficulty.speed
	
	# We iterate
	while true:
		
		# If we can spawn the note
		if list[ index ].time - ( 1 / speed ) < playfield.time.get_time( ):
			
			# We create a new note
			var ins = BasicNote.instance( )
			
			# setup the note
			ins.time = list[ index ].time
			ins.y_pos = list[ index ].y_pos
			ins.samples = list[ index ].samples
			ins.local_volume = list[ index ].local_volume
			ins.volume = list[ index ].volume
			
			ins.playfield = playfield
			ins.manager = self
			
			# We add the new instance to the notes holder
			notes_holder.add_child( ins )
			# We go to the next note.
			index += 1
		
		# We stop here if there are no spawnable notes.
		else:
			break
		
		
		# If we are at the end of the list
		if index >= list.size( ):
			# We stop here
			break




### @brief Replace the notes at their right place in the screen.
###
func replace_notes( ):
	
	# We iterate over the children
	for n in notes_holder.get_children( ):
		
		# And called the resized event.
		n.on_playfield_resized( )




### @brief Get the first alive note (the first not played note visible on the screen).
###
### @return The first alive note, or null.
###
func get_first_alive( ):
	
	# We iterate over the notes' node
	for n in notes_holder.get_children( ):
		
		# If the note isn't played
		if not n.played:
			
			# We return it.
			return n
	
	# Otherwise, we return null.
	return null




### @brief Get the first note.
###
### @return The first note, or null.
###
func get_first( ):
	
	# If there are no notes
	if list.size( ) == 0:
		# We return null
		return null
	
	# Otherwise, we return the first note.
	return list[ 0 ]


### @brief Get the last note.
###
### @return The last note, or null.
###
func get_last( ):
	
	# If there are no notes
	if list.size( ) == 0:
		# We return null
		return null
	
	# Otherwise, we return the last note.
	return list[ list.size( ) - 1 ]