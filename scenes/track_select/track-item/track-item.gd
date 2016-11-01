### @class TrackItem
###
### @brief A track item in the tracks grid
###



extends Panel




### @brief The track's path.
var track_path
### @brief The track's DB entry.
var db_entry

### @brief The thumbnail sprite.
onready var thumbnail = get_node( "thumbnail" )
### @brief The color tween.
var color_tween

### @brief Normal color of the thumbnail.
var normal_color = Color8( 70,70,70 )
### @brief Hovered color of the thumbnail.
var hovered_color = Color8( 160,160,160 )




### @brief Called when the node is ready in the tree.
###
func _ready():
	
	# We create the color tween.
	color_tween = Tween.new( )
	add_child( color_tween )
	
	# If the database entry is present
	if db_entry != null:
		
		# We set the labels.
		get_node( "title" ).set_text( db_entry.title )
		get_node( "artist" ).set_text( db_entry.artist )
		get_node( "name" ).set_text( db_entry.name )
	
	# If the database entry does not exist
	else:
		
		# We set the labels.
		get_node( "title" ).set_text( "No tracks" )
		get_node( "artist" ).set_text( "" )
		get_node( "name" ).set_text( "" )
		
		# And we center the title.
		get_node( "title" ).set_align( Label.ALIGN_CENTER )
	
	# We enable the input process.
	set_process_input( true )




### @brief Called when the thumbnail is loaded.
###
func on_thumbnail_loaded( tex ):
	
	# We set the sprite's texture.
	thumbnail.set_texture( tex )
	
	# We compute the scale
	var scale = get_size( ) / tex.get_size( )
	
	# We keep the aspect ration.
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	# We compute the texture rect
	var rect = Rect2( 0, 0, 0, 0 )
	
	# We compute the ration
	var ratio = get_size( ).x / get_size( ).y
	
	# We compute the width and the height of the sprite.
	var width = tex.get_size( ).x * scale.x
	var height = tex.get_size( ).y * scale.y
	
	# We keep the smallest between the width and the height
	if width < height:
		height = width / ratio
	
	else:
		width = height * ratio
	
	# We compute the texture width and height
	width /= scale.x
	height /= scale.y
	
	# Setup the texture region rectangle
	rect.pos.x = tex.get_size( ).x / 2 - width / 2
	rect.pos.y = tex.get_size( ).y / 2 - height / 2
	rect.size.x = width
	rect.size.y = height
	
	# We set the scale, the position and the texture region rectangle.
	thumbnail.set_scale( scale )
	thumbnail.set_pos( get_size( ) / 2 )
	thumbnail.set_region_rect( rect )
	
	# We play the show animation.
	get_node( "thumbnail/animation" ).play( "show" )




### @brief Called when an input event is received.
###
func _input_event( event ):
	
	# If there are no database entru
	if db_entry == null:
		# We do nothing
		return
	
	# If the event is a left button click
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed( ) and event.button_index == BUTTON_LEFT:
		
		# We get the local mouse position
		var m_pos = get_local_mouse_pos( )
		
		# If the control's rect has the point in it
		if get_rect( ).has_point( m_pos ):
			# We open the track information.
			get_node( "../../../.." ).open_track_info( db_entry )




### @brief Signal: `self.mouse_enter`
###
func _on_mouse_enter():
	
	# We setup the color tween.
	color_tween.interpolate_property( thumbnail, "modulate", \
		thumbnail.get_modulate( ), hovered_color, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	# And start it
	color_tween.start( )


### @brief Signal: `self.mouse_exit`
###
func _on_mouse_exit():
	
	# We setup the color tween.
	color_tween.interpolate_property( thumbnail, "modulate", \
		thumbnail.get_modulate( ), normal_color, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	# And start it.
	color_tween.start( )
