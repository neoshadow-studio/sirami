### @class BasicNote
###
### @brief A basic note.
###



extends Sprite




const Audio = preload( "../parts/audio.gd" )




### @brief The note's type.
var type = "basic"

### @brief The note's time.
var time
### @brief The Y position of the note.
var y_pos

### @brief The note's samples.
var samples = Audio.SAMPLE_NONE

### @brief Define if the note has its own volume.
var local_volume = false
### @brief The volume of the note.
var volume = 1

### @brief The playfield.
var playfield
### @brief The note manager.
var manager

### @brief The speed of the note.
var speed

### @brief Define if the note has been played.
var played = false




### @brief Called when the node is ready in the tree.
###
func _ready():
	
	# We resize the note.
	on_playfield_resized( )
	
	# We enable the fixed process update.
	set_fixed_process( true )




### @brief Called when the playfield is resized.
###
func on_playfield_resized( ):
	
	# We get the speed of the notes
	speed = playfield.track.difficulty.speed * playfield.get_size( ).x
	var size = playfield.track.difficulty.size
	
	# We compute the new scale of the note
	var scale = (playfield.get_size( ).y * 0.1 * size) / get_texture( ).get_size( ).y
	set_scale( Vector2( scale, scale ) )
	
	# We compute the Y position of the note.
	var y = playfield.get_size( ).y - ( get_texture( ).get_size( ).y * scale )
	y = y * y_pos + (get_texture( ).get_size( ).y * scale / 2)
	
	# We compute the X position of the note.
	var x = playfield.visual.timeline_offset + (time - playfield.time.get_time( )) * speed
	
	# We set the new position.
	set_pos( Vector2( x, y ) )




### @brief Updates the note.
###
### @param dt : The delta-time.
###
func _fixed_process( dt ):
	
	# If the note is played
	if played:
		# We do nothing.
		return
	
	
	# We compute the new X position of the note.
	var x = playfield.visual.timeline_offset + (time - playfield.time.get_time( )) * speed
	
	# We get the actual pos and change the X position.
	var p = get_pos( )
	p.x = x
	
	# We set the X position of the note.
	set_pos( p )
	
	
	# TODO: Handle auto mode.
	
	# We the note is totally missed
	if time < playfield.time.get_time( ) and not playfield.score.can_be_played( self ):
		
		play( )




### @brief Plays the note.
###
### @param auto : Played by the auto mod ?
###
func play( auto = false ):
	
	# If the note is already played
	if played:
		# we do nothing.
		return
	
	# We indicate the note is played.
	played = true
	
	
	# We get the score
	var score = playfield.score.get_score( self )
	
	# If there are the auto mode
	if auto:
		# We force the score to the 100
		score = 100
	
	
	# If the score isn't miss
	if score != 0:
		
		# If the note has a local volume
		if local_volume:
			# We play the samples with the volume
			playfield.audio.play_samples( samples, volume )
		
		# If the note hasn't has a local volume
		else:
			# We play the samples with the default volume
			playfield.audio.play_samples( samples )
	
	
	# We emit the played signal
	playfield.notes.emit_signal( "played", self, score )
	
	
	# We add the score
	playfield.score.add_score( score )
	
	# We play the fade out animation.
	get_node( "anim" ).play( "fade" )




### @brief Checks if the cursor is in the note.
###
### @param cursor_y : The Y position of the curosr.
### @return true if the cursor is in, false otherwise.
###
func is_cursor_in( ):
	
	# We get the cursor position.
	var cursor_y = playfield.get_node( "low-gui/cursor" ).get_pos( ).y
	
	# We compute the top and bottom Y position.
	var top = get_pos( ).y - ( get_texture( ).get_size( ).y * get_scale( ).y / 2 )
	var bottom = get_pos( ).y + ( get_texture( ).get_size( ).y * get_scale( ).y / 2 )
	
	# If the cursor is between the top and the bottom
	if cursor_y > top and cursor_y < bottom:
		# The cursor is in the note
		return true
	
	# Otherwise, the note is not in the note.
	return false




# @brief Signal: `anim.finished`
func _on_anim_finished():
	
	# We remove the note.
	queue_free( )
	manager.notes_holder.remove_child( self )




### @brief Create a new instance from loaded data.
###
### @param d : Raw data.
### @return The new instance.
###
static func from_data( d ):
	
	# We parse the note's string.
	var time
	var y_pos
	var samples
	var local_volume
	var volume
	
	var data = d.split( ";" )
	time = float( data[ 1 ] )
	y_pos = float( data[ 2 ] )
	samples = int( data[ 3 ] )
	local_volume = data[ 4 ] == "true"
	volume = float( data[ 5 ] )
	
	
	# We create a new instance.
	var ins = new( )
	
	# Setup its values
	ins.time = time
	ins.y_pos = y_pos
	ins.samples = samples
	ins.local_volume = local_volume
	ins.volume = volume
	
	# And return it.
	return ins



### @brief Converts the instance to savable data.
###
### @return Savable data.
###
func to_data( ):
	
	var s = ""
	
	s += "basic;%d;%d;%d;%s;%d" % [
		time, y_pos, samples,
		(local_volume and "true" or "false"),
		volume
	]
	
	return s