### @class Music
###
### @brief A simple auto-loaded node which handles
### the music and the time of the music.
###



extends StreamPlayer




### @brief The clocks.
onready var clocks = get_node( "/root/clocks" )
### @brief The settings manager.
onready var settings = get_node( "/root/settings" )



### @brief Last position returned by the stream player.
###
var last_playhead = 0




### @brief Called when the node is ready in the tree.
###
func _ready():
	
	# We add the clock "music"
	clocks.add_clock( "music" )
	
	# We connect the changed signal.
	settings.connect( "changed", self, "_on_setting_changed" )
	
	# And enable the fixed process.
	set_fixed_process( true )




### @brief Reset the music.
###
func reset( ):
	
	last_playhead = 0
	clocks.set_time( "music", 0 )




### @brief Starts the stream playback.
###
### @param pos : Time in the music.
###
func play( pos=0 ):
	
	last_playhead = pos
	clocks.enable( "music" )
	clocks.set_time( "music", pos )
	.play( pos )


### @brief Seeks to the given position.
###
### @param pos : Time to seek.
###
func seek_pos( pos ):
	
	last_playhead = pos
	clocks.set_time( "music", pos )
	.seek_pos( pos )




### @brief Called at a regular rate.
###
### @param dt : The delta-time.
###
func _fixed_process( dt ):
	
	# If we are not playing
	if not is_playing( ):
		# We do nothing
		return
	
	
	# If the stream has changed its position.
	if get_pos( ) != last_playhead:
		
		# We update the time of the music clock
		clocks.set_time( "music", ( clocks.get_time( "music" ) + get_pos( ) ) / 2 )
		# And we keep the new position.
		last_playhead = get_pos( )


### @brief Signal: `settings.changed`
###
func _on_setting_changed( section, name, new_value, old_value ):
	
	# If an audio setting was changed
	if section == "audio":
		
		# we compute the music volume
		var new_vol = settings.get_setting( "audio", "global_volume" )
		new_vol *= settings.get_setting( "audio", "music_volume" ) 
		
		# And set it.
		set_volume( new_vol )