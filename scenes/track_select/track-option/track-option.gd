### @class TrackOption
###
### @brief Track options before playing.
###



extends Container




const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )
const Playfield = preload( "res://scenes/playfield/playfield.tscn" )




### @brief The settings manager.
onready var settings = get_node( "/root/settings" )
### @brief The scene switcher.
onready var scene_switcher = get_node( "/root/scene_switcher" )
### @brief The background manager.
onready var background = get_node( "/root/background" )

### @brief The background node.
onready var n_bg = get_node( "background" )
### @brief The title label.
onready var n_title = get_node( "title" )
### @brief The artist label.
onready var n_artist = get_node( "artist" )
### @brief The name label.
onready var n_name = get_node( "name" )
### @brief The mapper label.
onready var n_mapper = get_node( "mapper" )

### @brief The duration label.
onready var n_duration = get_node( "duration" )
### @brief The music player.
onready var n_music = get_node( "music" )

### @brief The auto mode checkbox.
onready var n_auto_mode = get_node( "play_cont/auto_mode" )

### @brief The database entry.
var db_entry

### @brief The auto mode is enabled ?
var auto_mode = false
### @brief The back was pressed ?
var back_pressed = false




### @brief Called when the node is ready in the tree.
###
func _ready():
	
	# We set the labels' value.
	n_title.set_text( db_entry.title )
	n_artist.set_text( db_entry.artist )
	n_name.set_text( db_entry.name )
	n_mapper.set_text( db_entry.mapper )
	
	
	# We load the background texture.
	var tex = load( db_entry.path.get_base_dir( ) + "/" + db_entry.background )
	
	# If the load failed
	if not tex:
		# We spawn a notification
		get_node( "/root/notifications" ).spawn_basic( "Failed to load background." )
	
	# If the load was successful
	else:
		# We set the background texture.
		n_bg.set_texture( tex )
		
		# We connect the resized signal.
		connect( "resized", self, "_on_resized" )
		_on_resized( )
	
	
	# We load the stream.
	var stream = load( db_entry.path.get_base_dir( ) + "/" + db_entry.music )
	
	# If the load failed.
	if not stream:
		
		get_node( "/root/notifications" ).spawn_basic( "Failed to load music." )
	
	# If the load was successful
	else:
		
		# We set the music stream
		n_music.set_stream( stream )
		# And start it at the preview time.
		n_music.play( db_entry.preview_time )
		# And set its volume to 0
		n_music.set_volume( 0 )
		
		# We start the fade in effect on the volume.
		_fade_in_music( )
		
		# We compute the duration of the music
		var mins = int( n_music.get_length( ) / 60 )
		var seconds = int( n_music.get_length( ) - 60 * mins )
		
		# And we set the duration label.
		n_duration.set_text( "Duration : %d:%d" % [mins, seconds] )
	
	# We enable the process input.
	set_process_input( true )




### @brief Signal: `self.resized`
###
func _on_resized( ):
	
	# We compute the scale
	var scale = get_size( ) / n_bg.get_texture( ).get_size( )
	
	# We keep the aspect ratio
	if scale.x > scale.y:
		scale.y = scale.x
	
	else:
		scale.x = scale.y
	
	# We set the scale and the position.
	n_bg.set_scale( scale )
	n_bg.set_pos( get_size( ) / 2 )




### @brief Signal: `play_cont/auto_mode.pressed`
###
func _on_auto_mode_pressed():
	# Toogle the auto mode.
	auto_mode = not auto_mode




### @brief Signal: `anim.finished`
###
func _on_anim_finished():
	
	# If the back button was pressed
	if back_pressed: 
		
		# We remove the scene.
		self.queue_free( )
		get_parent( ).remove_child( self )




### @brief Process the input event.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If the escape key is pressed.
	if ev.is_action_pressed( "pause" ):
		# We emulate a click on the back button.
		_on_back_pressed( )


### @brief Signal: `bacl.pressed`
###
func _on_back_pressed():
	
	# We indicate that the back button was pressed
	back_pressed = true
	
	# We start the fade out effect on the scene and on the music.
	get_node( "anim" ).play( "fadeout" )
	_fade_out_music( )




### @brief Signal: `play_cont/play.pressed`
###
func _on_play_pressed( ):
	
	# We create a new ini stream.
	var ini = IniStream.new( db_entry.path )
	ini.namespace = "track"
	
	# We get the raw track data.
	var data = ini.read( )
	
	# If the load failed
	if data == null:
		
		# We spawn a notification and stop here.
		get_node( "/root/notifications" ).spawn_basic( \
			 "Can't load track from '" + db_entry.path + "' !" )
		return
	
	
	# We convert the raw data into an object
	var track = Track.from_data( data )
	# We setup the instance
	track.base_dir = db_entry.path.get_base_dir( )
	
	
	# We create a new playfield instance.
	var pf = Playfield.instance( )
	
	# We setup the instance
	pf.track = track
	pf.mods_options = {
		"auto_mod": auto_mode
	}
	
	# We set its opacity to 0
	pf.set_opacity( 0 )
	
	
	# We get the root node
	var root = get_tree( ).get_root( )
	# We get the track select node
	var track_select = root.get_child( root.get_child_count( ) - 2 )
	
	# We remove it
	track_select.finish_thread( )
	track_select.queue_free( )
	root.remove_child( track_select )
	
	# We apply a fade out effect on the music
	_fade_out_music( )
	
	# We hide the local background
	n_bg.hide( )
	
	# We hide the sirami logo
	background.hide_logo( true )
	# And define the background texture
	background.define( n_bg.get_texture( ), true )
	
	# We switch to the playfield.
	scene_switcher.switch_with_fade( self, pf )




### @brief Apply a fade in effect on the music.
###
func _fade_in_music( ):
	
	# We compute the final speed.
	var vol = settings.get_setting( "audio", "global_volume", 1 ) * settings.get_setting( "audio", "music_volume", 1 )
	
	# We get the tween
	var t = n_music.get_node( "tween" )
	
	# We setup the tween.
	t.interpolate_method( n_music, "set_volume", 0, vol, 1, \
		Tween.TRANS_SINE, Tween.EASE_OUT )
	
	# We start the tween.
	t.start( )


### @brief Apply a fade out effect on the music.
###
func _fade_out_music( ):
	
	# We get the tween
	var t = n_music.get_node( "tween" )
	
	# We setup the tween.
	t.interpolate_method( n_music, "set_volume", n_music.get_volume( ), 0, 1, \
		Tween.TRANS_SINE, Tween.EASE_OUT )
	
	# We start the tween.
	t.start( )