### @class VolumeControl
###
### @brief Allow the change of the volume ingame.
###



extends CanvasLayer




### @brief The root control.
onready var control = get_node( "control" )

### @brief The global volume range.
onready var global = get_node( "control/global" )
### @brief The samples volume range.
onready var samples = get_node( "control/samples" )
### @brief The music volume range.
onready var music = get_node( "control/music" )

### @brief The global volume label.
onready var global_l = get_node( "control/global-label" )
### @brief The samples volume label.
onready var samples_l = get_node( "control/samples-label" )
### @brief The music volume label.
onready var music_l = get_node( "control/music-label" )

### @brief The last hovered range.
onready var last_hovered = global
### @brief The last hovered range's text.
onready var last_text = get_node( "control/text-global" )

### @brief The mouse is in the root control ?
onready var mouse_in = false




### @brief Called when the node is ready in the tree.
###
func _ready():
	
	# We set the starting value of the volumes.
	global.set_value( settings.get_setting( "audio", "global_volume", 1 ) )
	samples.set_value( settings.get_setting( "audio", "samples_volume", 1 ) )
	music.set_value( settings.get_setting( "audio", "music_volume", 1 ) )
	
	# We set the texts of the volumes.
	global_l.set_text( "%d %%" % ( global.get_value( ) * 100 ) )
	samples_l.set_text( "%d %%" % ( samples.get_value( ) * 100 ) )
	music_l.set_text( "%d %%" % ( music.get_value( ) * 100 ) )
	
	# We enable the input process.
	set_process_input( true )




### @brief Process the given event.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If the volume up or the volume down action is pressed
	if ev.is_action_pressed( "volume_up" ) or ev.is_action_pressed( "volume_down" ):
		
		# If the control is not visible
		if not control.is_visible( ):
			
			# We play the show animation
			get_node( "control/animation" ).play( "show" )
			# And starts the fade out timer.
			get_node( "control/timer" ).start( )
		
		# If the control is visible
		else:
			
			# If we increase the volume
			if ev.is_action_pressed( "volume_up" ):
				last_hovered.set_value( last_hovered.get_value( ) + 0.05 )
			
			# If we decrease the volume
			else:
				last_hovered.set_value( last_hovered.get_value( ) - 0.05 )
			
			# If the cursor isn't in the root control
			if not mouse_in:
				# We restart the fadeout timer.
				get_node( "control/timer" ).start( )
	
	
	# If the mouse moved
	if ev.type == InputEvent.MOUSE_MOTION:
		
		# And if we are visible
		if control.is_visible( ):
			
			# The mouse is in the root control ?
			var m_in = get_node( "control").get_rect( ).has_point( control.get_global_mouse_pos( ) )
			
			# If the mouse entered the root control
			if m_in and not mouse_in:
				# We define the mouse in the control
				mouse_in = true
				get_node( "control/timer" ).stop( )
			
			# If the mouse exited the root control
			if not m_in and mouse_in:
				# We define the mouse out of the control
				mouse_in = false
				get_node( "control/timer" ).start( )
			
			
			# We reset the text color of the label
			last_text.add_color_override( "font_color", Color( 1, 0, 1 ) )
			
			# If the global volume range is hovered
			if global.get_rect( ).has_point( control.get_local_mouse_pos( ) ):
				last_hovered = global
				last_text = get_node( "control/text-global" )
			
			# If the samples volume range is hovered
			if samples.get_rect( ).has_point( control.get_local_mouse_pos( ) ):
				last_hovered = samples
				last_text = get_node( "control/text-samples" )
			
			# If the music volume range is hovered
			if music.get_rect( ).has_point( control.get_local_mouse_pos( ) ):
				last_hovered = music
				last_text = get_node( "control/text-music" )
			
			# We set the font of the new hovered range's text.
			last_text.add_color_override( "font_color", Color( 0, 1, 0 ) )




### @brief Signal: `control/global.value_changed`
###
func _on_global_value_changed( value ):
	
	settings.set_setting( "audio", "global_volume", value )
	global_l.set_text( "%d %%" % ( value * 100 ) )


### @brief Signal: `control/samples.value_changed`
###
func _on_samples_value_changed( value ):
	
	settings.set_setting( "audio", "samples_volume", value )
	samples_l.set_text( "%d %%" % ( value * 100 ) )


### @brief Signal: `control/music.value_changed`
###
func _on_music_value_changed( value ):
	
	settings.set_setting( "audio", "music_volume", value )
	music_l.set_text( "%d %%" % ( value * 100 ) )




func _on_timer_timeout( ):
	
	get_node( "control/animation" ).play( "hide" )