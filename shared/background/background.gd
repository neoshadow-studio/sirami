### @class Background
###
### @brief Handle the scenes backgrounds.
###


extends Node




### @brief The modulate color of the background.
###
const MODULATE = Color8( 50, 50, 50 )




### @brief Called when the node is ready in the scene tree.
###
func _ready():

	get_tree( ).connect( "screen_resized", self, "_on_screen_resized" )




### @brief Define the new background texture.
###
### @param texture : The new background texture.
###
func define( texture, instant=false ):
	
	var current
	
	# If there are an actual background.
	if has_node( "current" ):
		
		# We get it, rename it and change itz Z depth.
		current = get_node( "current" )
		current.set_name( "old" )
		current.set_z( -101 )
	
	
	# We create the new background sprite.
	var new = Sprite.new( )
	# We set its name, its texture, its modulate color and its opacity
	new.set_name( "current" )
	new.set_texture( texture )
	new.set_modulate( MODULATE )
	new.set_opacity( 0 )
	# We add the new background to the node
	add_child( new )
	
	
	# If there are already a background.
	if current != null:
		# We set the new sprite to be on the top of the old sprite.
		new.set_z( -100 )
	
	# If there are no background actually.
	else:
		# We set the Z depth of the new sprite.
		new.set_z( -101 )
	
	
	if not instant:
		
		# We create the fade in tween, set its name and add it to the node.
		var fade_in_tween = Tween.new( )
		fade_in_tween.set_name( "fade-in" )
		add_child( fade_in_tween )
		
		# We connect the tween complete signal
		fade_in_tween.connect( "tween_complete", self, "_on_fade_in_tween_completed" )
		
		# We interpolate the new sprite's opacity.
		fade_in_tween.interpolate_property( new, "visibility/opacity", \
			0, 1, 1, Tween.TRANS_SINE, Tween.EASE_OUT )
		
		# We start the fade in tween.
		fade_in_tween.start( )
	
	else:
		
		if current != null:
			
			current.queue_free( )
			remove_child( current )
		
		new.set_opacity( 1 )
	
	# We update the position and the scale of the sprite(s).
	_update_pos_and_scale( )


### @brief Remove the background.
###
func remove( ):
	
	# If the fade-in effect is still present.
	if has_node( "fade-in" ):
		
		# We get the tween and stop it
		var fade_in_tween = get_node( "fade-in" )
		fade_in_tween.stop_all( )
		
		# And we remove it.
		remove_child( fade_in_tween )
	
	
	# If there are an actual background
	if has( "current" ):
		
		# We get it 
		var current = get_node( "current" )
		
		# We create a new tween, set it's name and add it to the node.
		var fade_out_tween = Tween.new( )
		fade_out_tween.set_name( "fade-out" )
		add_child( fade_out_tween )
		
		# We connect the tween complete
		fade_out_tween.connect( "tween_complete", self, "_on_fade_out_tween_completed" )
		
		# We interpolate the opacity of the background
		fade_out_tween.interpolate_property( current, "visibility/opacity", \
			current.get_opacity( ), 0, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT )
		
		# We start the remove tween.
		fade_out_tween.start( )




### @brief Show the logo.
###
### @param instant : Instantly show the logo.
###
func show_logo( instant=false ):
	
	# We get the logo and the animation player
	var logo = get_node( "sirami-logo" )
	var anim = logo.get_node( "animation" )
	
	# If is the logo hidden
	if logo.is_hidden( ):
		
		# If we show instantly the logo
		if instant:
			# We show the logo and set its opacity to 1
			logo.show( )
			logo.set_opacity( 1 )
		
		# Otherwise
		else:
			# We play the show animation.
			anim.play( "show" )


### @brief Hide the logo.
###
func hide_logo( instant=false ):
	
	# Get the logo and the animation player
	var logo = get_node( "sirami-logo" )
	var anim = logo.get_node( "animation" )
	
	# If the logo visible
	if logo.is_visible( ) and not instant:
		# We play the hide animation.
		anim.play( "hide" )
	
	if instant:
		logo.hide( )




### @brief Updates the position and the scale of the background.
###
func _update_pos_and_scale( ):
	
	# If there are the old background present
	if has_node( "old" ):
		
		# We update its position and scale
		_update_pos_and_scale_for( get_node( "old" ) )
	
	# If there are a background
	if has_node( "current" ):
		
		# We update its position and scale.
		_update_pos_and_scale_for( get_node( "current" ) )
	
	# We update the logo.
	_update_logo( )




### @brief Update the pos and the scale of the logo.
###
func _update_logo( ):
	
	# We compute the new scale
	var scale = 0.4 * get_parent( ).get_rect( ).size / get_node( "sirami-logo" ).get_texture( ).get_size( )
	
	# We keep the aspect ratio
	if scale.x > scale.y:
		scale.y = scale.x
	
	else:
		scale.x = scale.y
	
	# We set the scale and the pos.
	get_node( "sirami-logo" ).set_scale( scale )
	get_node( "sirami-logo" ).set_pos( get_parent( ).get_rect( ).size / 2 )


### @brief Updates the position and the scale of a background sprite.
###
### @param node : The background sprite.
###
func _update_pos_and_scale_for( node ):
	
	# We get the texture size and the screen size.
	var tex_size = node.get_texture( ).get_size( )
	var screen_size = get_viewport( ).get_rect( ).size
	
	# We compute the basic scale.
	var scale = screen_size / tex_size
	
	# We keep the aspect ratio while filling the whole screen
	if scale.x < scale.y:
		scale.y = scale.x
	
	else:
		scale.x = scale.y
	
	# We set the scale and the position of the sprite.
	node.set_scale( scale )
	node.set_pos( screen_size / 2 )




### @brief Signal: `get_tree().screen_resized`
###
func _on_screen_resized( ):
	
	# We update the position and the scale of the background elements.
	_update_pos_and_scale( )




### @brief Signal: `fade_out_tween.tween_complete`
###
func _on_fade_out_tween_completed( obj, b ):
	
	# We get the fade out tween
	var fade_out_tween = get_node( "fade-out" )
	
	# We remove the old background sprite and the fade out tween.
	remove_child( obj )
	remove_child( fade_out_tween )


### @brief Signal: `fade_in_tween.tween_complete`
###
func _on_fade_in_tween_completed( obj, b ):
	
	if has_node( "old" ):
		
		remove_child( get_node( "old" ) )
	
	
	# We get the fade in tween
	var fade_in_tween = get_node( "fade-in" )
	
	# We remove it
	remove_child( fade_in_tween )
	
	# And set the background sprite Z depth
	obj.set_z( -100 )