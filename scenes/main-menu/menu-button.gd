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




### @brief 
func _process( dt ):
	
	if clicked:
		
		set_process( false )
		return
	
	if logo == null:
		
		logo = get_parent( ).logo
		return
	
	if logo.distance < 0:
		
		if hovered:
			
			hovered = false
			get_node( "anim" ).play( "normal" )
		
		return
	
	
	if start_angle > end_angle:
		
		if rad2deg( logo.angle ) > end_angle and rad2deg( logo.angle ) < start_angle and not hovered:
			
			hovered = true
			get_node( "anim" ).play( "hovered" )
		
		if ( rad2deg( logo.angle ) < end_angle or rad2deg( logo.angle ) > start_angle ) and hovered:
			
			hovered = false
			get_node( "anim" ).play( "normal" )

