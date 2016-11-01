### @class MainMenu_SiramiLogo
###
### @brief Sirami logo for the main menu.

extends Sprite




### @brief Angle of the mouse from the center of the screen.
var angle
### @brief Distance form the outside of the logo to the mouse position.
var distance

### @brief Radius of the logo.
var logo_radius = 0




### @brief Called when the node is ready in the scene.
###
func _ready( ):
	
	# We connect the screen resized signal
	get_tree( ).connect( "screen_resized", self, "_on_parent_resized" )
	_on_parent_resized( )
	
	# We enable the process.
	set_process( true )




### @brief Update the node.
###
### @param dt : The delta-time.
###
func _process( dt ):
	
	# We get the global mouse position.
	var m_pos = get_global_mouse_pos( )
	
	# We compute the angle and the distanec.
	angle = ( get_viewport( ).get_rect( ).size / 2 ).angle_to_point( m_pos ) + PI
	distance = ( m_pos - get_pos( ) ).length( ) - logo_radius




### @brief Signal: `get_tree( ).screen_resized`
###
func _on_parent_resized( ):
	
	# We compute the scale
	var scale = 0.4 * get_viewport( ).get_rect( ).size / get_texture( ).get_size( )
	
	# We keep the aspect ratio
	if scale.x > scale.y:
		scale.y = scale.x
	
	else:
		scale.x = scale.y
	
	# We set the scale and the position of the logo
	set_scale( scale )
	set_pos( get_viewport( ).get_rect( ).size / 2 )
	
	# And we compute the radius of the logo.
	logo_radius = get_texture( ).get_size( ).y * scale.x / 2