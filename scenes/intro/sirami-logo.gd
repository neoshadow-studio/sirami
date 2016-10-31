### @class SiramiLogo
###
### @brief The sirami logo.
###



extends Sprite




### @brief The background factor.
export( float, 0, 1, 0.001 ) var factor = 0 setget set_factor, get_factor
### @brief The background texture.
export( Texture ) var bg_texture




### @brief Called when the node is ready in the tree.
###
func _ready( ):
	
	# We connect the resized signal
	get_parent( ).connect( "resized", self, "_on_parent_resized" )
	_on_parent_resized( )




### @brief Set the factor.
###
### @param v : The new factor.
###
func set_factor( v ):
	
	# We keep the factor
	factor = v
	
	# If the factor is >= 1 and there are no texture
	if factor >= 1 and get_texture( ) == null:
		
		# We set the texture and update the scales.
		set_texture( bg_texture )
		set_scale( get_scale( ) * 2 )
		get_node( "sirami" ).set_scale( get_node( "sirami" ).get_scale( ) / 2 )
	
	# If there are no texture
	if get_texture( ) == null:
		
		# We redraw the node
		update( )


### @brief Get the factor.
###
### @return The factor.
###
func get_factor( ):
	
	return factor




### @brief Signal: `get_parent( ).resized`
###
func _on_parent_resized( ):
	
	var tex
	
	# We get the texture
	if factor >= 1:
		tex = get_texture( )
	else:
		tex = bg_texture
	
	# We compute the new scale
	var scale = 0.2 * get_parent( ).get_size( ) / tex.get_size( )
	
	# We keep the aspect ratio
	if scale.x > scale.y:
		scale.y = scale.x
	
	else:
		scale.x = scale.y
	
	# If there are a setted texture
	if get_texture( ) != null:
		# We increase the scale
		scale *= 2
	
	# We set the scale and the pos.
	set_scale( scale )
	set_pos( get_parent( ).get_size( ) / 2 )




### @brief Draw the node.
###
func _draw():
	
	# If there are a texture
	if get_texture( ) != null:
		# We do nothing
		return
	
	# If the factor is <= 0
	if factor <= 0:
		
		return
	
	
	var points = Vector2Array( )
	var colors = ColorArray( )
	var uvs = Vector2Array( )
	
	# If the factor is less than 0
	if factor < 1:
		
		# We add a point at the center
		points.push_back( Vector2( 0, 0 ) )
		colors.push_back( Color( 1, 1, 1 ) )
		uvs.push_back( Vector2( 0.5, 0.5 ) )
	
	# We draw the circle
	var f = 0
	while f <= 2*PI * factor:
		
		# We compute the sin and cos values
		var s = sin(f)
		var c = cos(f)
		
		# We compute the pos and the UVs
		var pos = Vector2( c * bg_texture.get_width( ), s * bg_texture.get_height( ) )
		var uv = Vector2( c * 0.5 + 0.5, s * 0.5 + 0.5 )
		
		# We add the point, the color and the UV
		points.push_back( pos )
		colors.push_back( Color( 1, 1, 1 ) )
		uvs.push_back( uv )
		
		# We increase the step
		f += 0.01
	
	# We draw only if there are more than 3 points
	if points.size( ) >= 3:
		draw_polygon( points, colors, uvs, bg_texture )
