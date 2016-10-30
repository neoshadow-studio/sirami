
extends Sprite

export( float, 0, 1, 0.001 ) var factor = 0 setget set_factor, get_factor
export( Texture ) var bg_texture



func _ready( ):
	
	get_parent( ).connect( "resized", self, "_on_parent_resized" )
	_on_parent_resized( )


func set_factor( v ):
	
	factor = v
	
	if factor >= 1 and get_texture( ) == null:
		
		set_texture( bg_texture )
		set_scale( get_scale( ) * 2 )
		get_node( "sirami" ).set_scale( get_node( "sirami" ).get_scale( ) / 2 )
	
	update( )


func get_factor( ):
	
	return factor




func _on_parent_resized( ):
	
	var tex
	
	if factor >= 1:
		tex = get_texture( )
	else:
		tex = bg_texture
	
	var scale = 0.2 * get_parent( ).get_size( ) / tex.get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	
	if get_texture( ) != null:
		
		scale *= 2
	
	set_scale( scale )
	set_pos( get_parent( ).get_size( ) / 2 )




func _draw():
	
	if get_texture( ) != null:
		
		return
	
	
	if factor <= 0:
		
		return
	
	var points = Vector2Array( )
	var colors = ColorArray( )
	var uvs = Vector2Array( )
	
	if factor < 1:
	
		points.push_back( Vector2( 0, 0 ) )
		colors.push_back( Color( 1, 1, 1 ) )
		uvs.push_back( Vector2( 0.5, 0.5 ) )
	
	var f = 0
	while f <= 2*PI * factor:
		
		var s = sin(f)
		var c = cos(f)
		
		var pos = Vector2( c * bg_texture.get_width( ), s * bg_texture.get_height( ) )
		var uv = Vector2( c * 0.5 + 0.5, s * 0.5 + 0.5 )
		
		points.push_back( pos )
		colors.push_back( Color( 1, 1, 1 ) )
		uvs.push_back( uv )
		
		f += 0.01
	
	if points.size( ) >= 3:
		
		draw_polygon( points, colors, uvs, bg_texture )

