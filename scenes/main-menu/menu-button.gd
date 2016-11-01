### @class MenuButton
###
### @brief A main menu button.
###



extends Control




### @brief The next scene to load.
export( String, FILE, "*.tscn" ) var next_scene

### @brief The starting angle of the button.
export( float, 0, 360, 1 ) var start_angle = 0
### @brief The ending angle of the button.
export( float, 0, 360, 1 ) var end_angle = 0

### @brief The sirami logo.
var logo

### @brief Is the button hovered ?
var hovered = false
### @brief Is the button was clicked ?
var clicked = false




### @brief Called when the node in ready in the scene.
###
func _ready():
	
	# We get the sirami logo
	logo = get_parent( ).logo
	
	# We connect the resized signal.
	get_parent( ).connect( "resized", self, "_on_parent_resized" )
	# We update the background polygon
	_update_background( )
	
	# We enable the process and the input event.
	set_process( true )
	set_process_input( true )




### @brief Called when the ndoe receive an input event.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If there are no logo
	if logo == null or logo.angle == null:
		# We do nothing.
		return
	
	# If this is a mouse left click
	if ev.type == InputEvent.MOUSE_BUTTON and ev.is_pressed( ) and ev.button_index == BUTTON_LEFT:
		
		# If the mouse is in the button and the button is hovered.
		if rad2deg( logo.angle ) > end_angle and rad2deg( logo.angle ) < start_angle and hovered:
			
			# If there are no scene
			if next_scene.empty( ):
				
				# We quit the game
				get_tree( ).quit( )
				return
			
			# We load the next scene
			var scene = load( next_scene )
			
			# If the scene failed to load
			if scene == null:
				# We show a notification and stop here
				get_node( "/root/notifications").spawn_basic( "Failed to load scene '" + next_scene + "' !" )
				return 
			
			# We create a new instance
			var ins = scene.instance( )
			
			# We swtich the scene.
			scene_switcher.switch_with_fade( get_parent( ), ins )




### @brief Update the button.
###
func _process( dt ):
	
	get_node( "polygon" ).set_scale( Vector2( 1, 1 ) / get_scale( ) )
	
	
	# If the button is clicked
	if clicked:
		
		# We stop the process and stop here
		set_process( false )
		return
	
	# If the logo doesn't exists
	if logo == null:
		
		# We get it from the parent and stop here
		logo = get_parent( ).logo
		return
	
	# If the distance is less than 0
	if logo.distance < 0:
		
		# If the button is hovered
		if hovered:
			# We disable the hovered state.
			hovered = false
			get_node( "anim" ).play( "normal" )
		
		return
	
	# If the angles is correctly configured
	if start_angle > end_angle:
		
		# If the mouse is in the button
		if rad2deg( logo.angle ) > end_angle and rad2deg( logo.angle ) < start_angle and not hovered:
			# We setup the hovered state
			hovered = true
			get_node( "anim" ).play( "hovered" )
		
		# If the mouse is no longer is the button
		if ( rad2deg( logo.angle ) < end_angle or rad2deg( logo.angle ) > start_angle ) and hovered:
			# We exit the hovered state.
			hovered = false
			get_node( "anim" ).play( "normal" )




### @brief Signal: `parent.resized`
###
func _on_parent_resized( ):
	# We update the background.
	_update_background( )




### @brief Convert a radian position to a cartesien position.
###
### @param angle : The angle
### @param factor : The distance factor.
###
func _rad_to_cartesien( angle, factor ):
	
	# We compute the distance
	var distance = get_parent( ).get_size( ).x / 2 * factor * 2
	
	# We compute the position
	var pos = Vector2( sin( angle ) * distance, cos( angle ) * distance )
	pos = get_parent( ).get_size( ) / 2 + pos
	
	# And make it local
	return make_canvas_pos_local( pos )


### @brief Update the background polygon.
###
func _update_background( ):
	
	# We compute the 3 positions
	var pos0 = _rad_to_cartesien( deg2rad( start_angle ), 0 )
	var pos1 = _rad_to_cartesien( deg2rad( start_angle ), 1 )
	var pos2 = _rad_to_cartesien( deg2rad( end_angle ), 1 )
	
	# And we set the polygon's mesh.
	var poly = get_node( "polygon" )
	poly.set_polygon( Vector2Array( [pos0, pos1, pos2] ) )