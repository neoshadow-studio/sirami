### @class Options
###
### @brief The options screen.
###


extends Control




const MainMenu = preload( "res://scenes/main-menu/main-menu.tscn" )




### @brief The global volume range.
onready var global_val = get_node( "scroll/vbox/global/value" )
### @brief The samples volume range.
onready var samples_val = get_node( "scroll/vbox/samples/value" )
### @brief The music volume range.
onready var music_val = get_node( "scroll/vbox/music/value" )

### @brief The global volume text.
onready var global_text = get_node( "scroll/vbox/global/text" )
### @brief The samples volume text.
onready var samples_text = get_node( "scroll/vbox/samples/text" )
### @brief The music volume text.
onready var music_text = get_node( "scroll/vbox/music/text" )

### @brief The hide background check box.
onready var hide_bg = get_node( "scroll/vbox/hide/background" )
### @brief The hide sirami logo check box.
onready var hide_sirami = get_node( "scroll/vbox/hide/sirami-logo" )

### @brief The left key button.
onready var key_left = get_node( "scroll/vbox/left/button" )
### @rief The right key button
onready var key_right = get_node( "scroll/vbox/right/button" )

### @brief The key we are wainting an input for.
var wait_input_for = null




### @brief Called when the node is ready in the scene.
###
func _ready( ):
	
	# We connect the changed signal
	settings.connect( "changed", self, "_on_setting_changed" )
	
	
	# We setup the starting values of the volume ranges
	global_val.set_value( settings.get_setting( "audio", "global_volume", 1 ) )
	samples_val.set_value( settings.get_setting( "audio", "samples_volume", 1 ) )
	music_val.set_value( settings.get_setting( "audio", "music_volume", 1 ) )
	
	# We define the volume values texts.
	global_text.set_text( "%d %%" % ( global_val.get_value( ) * 100 ) )
	samples_text.set_text( "%d %%" % ( samples_val.get_value( ) * 100 ) )
	music_text.set_text( "%d %%" % ( music_val.get_value( ) * 100 ) )
	
	# We setup the starting value of the hide checkboxs.
	hide_bg.set_pressed( settings.get_setting( "playfield", "hide_background", false ) )
	hide_sirami.set_pressed( settings.get_setting( "playfield", "hide_sirami", false ) )
	
	# We define the text of the keys buttons.
	key_left.set_text( OS.get_scancode_string( settings.get_setting( "keys", "left", KEY_W ) ) )
	key_right.set_text( OS.get_scancode_string( settings.get_setting( "keys", "right", KEY_X ) ) )
	
	# We disable the volume control.
	volume_control.enabled = false


### @brief Called when the node exists the tree.
###
func _exit_tree( ):
	
	# We disconnect the changed signal
	settings.disconnect( "changed", self, "_on_setting_changed" )
	# And reenable the volume control.
	volume_control.enabled = true




### @brief Called when an input event is received.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If the ev is a key
	if ev.type == InputEvent.KEY:
		
		# If the key is escape
		if ev.scancode == KEY_ESCAPE:
			
			# We reset the state of the button and we don't change the settings.
			if wait_input_for == "left":
				key_left.set_text( OS.get_scancode_string( settings.get_setting( "keys", "left", KEY_W ) ) )
			
			else:
				key_right.set_text( OS.get_scancode_string( settings.get_setting( "keys", "right", KEY_X ) ) )
			
		# If the key isn't escape
		else:
			
			# If we are waiting the input for the left key
			if wait_input_for == "left" :
				
				settings.set_setting( "keys", "left", ev.scancode )
				key_left.set_text( OS.get_scancode_string( ev.scancode ) )
			
			# If we are waiting the input for the right key
			else:
				
				settings.set_setting( "keys", "right", ev.scancode )
				key_right.set_text( OS.get_scancode_string( ev.scancode ) )
		
		# We reload the actions 
		settings.reload_keys( )
		
		# And remove the input process.
		wait_input_for = null
		set_process_input( false )




### @brief Signal: `scroll/vbox/global/value.changed`
###
func _on_global_volume_value_changed( value ):
	
	# We update the settings and the text
	settings.set_setting( "audio", "global_volume", value )
	global_text.set_text( "%d %%" % ( value * 100 ) )


### @brief Signal: `scroll/vbox/samples/value.changed`
###
func _on_samples_volume_value_changed( value ):
	
	# We update the settings and the text
	settings.set_setting( "audio", "samples_volume", value )
	samples_text.set_text( "%d %%" % ( value * 100 ) )


### @brief Signal: `scroll/vbox/music/value.changed`
###
func _on_music_volume_value_changed( value ):
	
	# We update the settings and the text
	settings.set_setting( "audio", "music_volume", value )
	music_text.set_text( "%d %%" % ( value * 100 ) )




### @brief Signal: `scroll/vbox/hide/background.pressed`
###
func _on_hide_background_pressed( ):
	
	# We update the settings.
	settings.set_setting( "playfield", "hide_background", hide_bg.is_pressed( ) )


### @brief Signal: `scroll/vbox/hide/sirami-logo.pressed`
###
func _on_hide_sirami_logo_pressed( ):
	
	# We update the settings.
	settings.set_setting( "playfield", "hide_sirami", hide_sirami.is_pressed( ) )




### @brief Signal: `scroll/vbox/left/button.pressed`
###
func _on_left_key_pressed( ):
	
	# If we are not waiting an input
	if wait_input_for == null:
		
		# We change the button's text
		key_left.set_text( "Waiting..." )
		
		# And wait for an input.
		wait_input_for = "left"
		set_process_input( true )


### @brief Signal: `scroll/vbox/right/button.pressed`
###
func _on_right_key_pressed( ):
	
	# If we are not waiting an input
	if wait_input_for == null:
		
		# We change the button's text
		key_right.set_text( "Waiting.." )
		
		# And wait for an input.
		wait_input_for = "right"
		set_process_input( true )




### @brief Signal: `back.pressed`
###
func _on_back_pressed( ):
	
	# We create a new instance
	var ins = MainMenu.instance( )
	
	# We switch with the main menu scene.
	scene_switcher.switch_with_fade( self, ins )




### @brief Signal: `settings.changed`
###
func _on_setting_changed( section, name, new_value, old_value ):
	
	# If an audio setting was changed
	if section == "audio":
			
			# We update the volumes ranges.
			global_val.set_value( settings.get_setting( "audio", "global_volume", 1 ) )
			samples_val.set_value( settings.get_setting( "audio", "samples_volume", 1 ) )
			music_val.set_value( settings.get_setting( "audio", "music_volume", 1 ) )
			
			# And the volumes texts.
			global_text.set_text( "%d %%" % ( settings.get_setting( "audio", "global_volume" ) * 100 ) )
			samples_text.set_text( "%d %%" % ( settings.get_setting( "audio", "samples_volume" ) * 100 ) )
			music_text.set_text( "%d %%" % ( settings.get_setting( "audio", "music_volume" ) * 100 ) )
