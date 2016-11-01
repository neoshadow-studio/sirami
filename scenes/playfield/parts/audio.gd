### @class Part_Audio
###
### @brief Audio part of the playfield.
###



extends Reference



### @brief No samples.
const SAMPLE_NONE = 0

### @brief Normal sample.
const SAMPLE_NORMAL = 0x01
### @brief Clap sample.
const SAMPLE_CLAP = 0x02
### @brief Finish sample.
const SAMPLE_FINISH = 0x04
### @brief Whistle sample.
const SAMPLE_WHISTLE = 0x08

### @brief All samples.
const SAMPLE_ALL = SAMPLE_NORMAL | SAMPLE_CLAP | SAMPLE_FINISH | SAMPLE_WHISTLE




### @brief The current playfield.
var playfield

### @brief The settings manager.
var settings
### @brief The music player.
var music

### @brief The samples player.
var samples

### @brief The global volume.
var global_volume
### @brief The music volume.
var music_volume
### @brief The sample volumes.
var samples_volume

### @brief The current samples volume. Value update by the timed object.
var current_samples_volume




### @brief Initializes the current instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	# We keep a ref to the playfield
	playfield = pf
	
	# We get the settings, the music, and the samples
	settings = pf.settings
	music = pf.music
	samples = pf.get_node( "samples" )
	
	# We update the volumes.
	update_volumes( )
	
	# We set the current samples volume.
	current_samples_volume = 1
	
	# We connect the changed signal of the settings.
	settings.connect( "changed", self, "_on_setting_changed" )
	
	# We start the music.
	_start_music( )




### @brief Updates the volumes.
###
func update_volumes( ):
	
	# We load the settings about the volume.
	global_volume = settings.get_setting( "audio", "global_volume", 1 )
	samples_volume = settings.get_setting( "audio", "samples_volume", 1 )
	music_volume = settings.get_setting( "audio", "music_volume", 1 )
	
	# We set the volume of the music player.
	music.set_volume( global_volume * music_volume )




### @brief Plays the gived samples.
###
### @param samples : The samples to play (bitfield).
### @param vol : The volume of the samples (optional).
###
func play_samples( smpls, vol = null ):
	
	# We must keep a track of the created voice.
	var voice
	
	
	# If we need to play the normal sample.
	if ( smpls & SAMPLE_NORMAL ) != 0:
		voice = samples.play( "normal" )
	
	# If we need to play the normal sample.
	if ( smpls & SAMPLE_CLAP ) != 0:
		voice = samples.play( "clap" )
	
	# If we need to play the normal sample.
	if ( smpls & SAMPLE_FINISH ) != 0:
		voice = samples.play( "finish" )
	
	# If we need to play the normal sample.
	if ( smpls & SAMPLE_WHISTLE ) != 0:
		voice = samples.play( "whistle" )
	
	
	# If a volume was passed.
	if vol != null:
		# We compute the volume of the created voice
		vol *= global_volume * samples_volume * vol
	
	# If no volume was passed.
	else:
		# We compute the volume of the created voice
		vol = global_volume * samples_volume * current_samples_volume
	
	
	# We set the volume of the created voice.
	samples.set_volume( voice, vol )




### @brief Starts the music.
###
func _start_music( ):
	
	# We get the full path of the music
	var path = playfield.track.music_path( )
	# We load it
	var stream = load( path )
	
	
	# If the load failed
	if stream == null:
		
		# We show a notification and stop here.
		playfield.notifications.spawn_basic( "Can't load music file '" + path + "' !" )
		return
	
	
	# We set the music's stream and play it.
	playfield.music.set_stream( stream )
	playfield.music.play( 300 )




### @brief Signal: `settings.changed`
###
### Updates the volumes if a volume setting was changed.
###
func _on_setting_changed( section, name, new_value, old_value ):
	
	# If a volume has changed
	if section == "audio" and name.find( "volume" ) != -1:
		# We update the volumes.
		update_volumes( )
