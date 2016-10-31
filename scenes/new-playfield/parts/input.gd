### @class Part_Input
###
### @brief Manage the inputs.
###



extends Reference




### @brief The playfield.
var playfield




### @brief Initialize a new instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf




### @brief Updates the inputs.
###
### @param dt : The delta-time.
###
func fixed_process( dt ):
	
	# We get the cursor and the mouse position
	var cursor = playfield.get_node( "low-gui/cursor" )
	var m_pos = playfield.get_global_mouse_pos( ).y
	
	
	# If the mouse is below the minimal cursor position
	if m_pos < cursor.get_texture( ).get_size( ).y * cursor.get_scale( ).y / 2:
		# We set the cursor position to 0
		playfield.logical.set_cursor_pos( 0 )
	
	# If the mouse is above the maximal cursor position
	elif m_pos > playfield.get_size( ).y - cursor.get_texture( ).get_size( ).y * cursor.get_scale( ).y / 2:
		# We set the cursor position to 1
		playfield.logical.set_cursor_pos( 1 )
	
	# If the mouse is in a valid position
	else:
		
		# We get the playfield size and the (scaled) texture size.
		var pf_size = playfield.get_size( )
		var tex_size = cursor.get_texture( ).get_size( ) * cursor.get_scale( )
		
		# We compute the factor
		var factor = ( m_pos - tex_size.y / 2 ) / ( pf_size.y - tex_size.y )
		# And set the cursor factor.
		playfield.logical.set_cursor_pos( factor )




### @brief Handles an input event.
###
### @param ev : The event.
###
func input( ev ):
	
	# We check if space is pressed for the skip
	if ev.type == InputEvent.KEY and ev.scancode == KEY_SPACE and playfield.logical.can_skip( ):
		# We skip
		playfield.logical.skip( )
	
	
	# If a key or a button is pressed
	if key_or_button_pressed( ev ):
		# We notify the logical part
		playfield.logical.on_key_pressed( )



### @brief Checks if a key or a mouse button is pressed.
###
### @param ev : The event (optional).
###
func key_or_button_pressed( ev = null ):
	
	# If we got an event to check
	if ev != null:
		
		# We check every keys/buttons
		var r = ev.is_action_pressed( "key_1" )
		r = r or ev.is_action_pressed( "key_2" )
		r = r or ev.is_action_pressed( "button_1" )
		r = r or ev.is_action_pressed( "button_2" )
		
		# Return the value
		return r
	
	# If we need to check the global input
	else:
		
		# We check every keys/buttons
		var r = Input.is_action_pressed( "key_1" )
		r = r or Input.is_action_pressed( "key_2" )
		r = r or Input.is_action_pressed( "button_1" )
		r = r or Input.is_action_pressed( "button_2" )
		
		# Return the value
		return r