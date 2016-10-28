
extends Panel



var track_path

var title = "Title"
var artist = "Artist"
var name = "Name"


onready var thumbnail = get_node( "thumbnail" )
var color_tween
var alpha_tween

var normal_color = Color8( 70,70,70 )
var hovered_color = Color8( 160,160,160 )



func _ready():
	
	color_tween = Tween.new( )
	add_child( color_tween )
	
	alpha_tween = Tween.new( )
	add_child( alpha_tween )
	
	
	get_node( "title" ).set_text( title )
	get_node( "artist" ).set_text( artist )
	get_node( "name" ).set_text( name )
	
	set_process_input( true )



func _input_event( event ):
	
	if event.is_action_pressed( "click" ):
		
		var m_pos = get_local_mouse_pos( )
		
		if get_rect( ).has_point( m_pos ):
			
			get_parent( ).load_track( track_path )



func on_thumbnail_loaded( tex ):
	
	thumbnail.set_texture( tex )
	
	var scale = get_size( ) / tex.get_size( )

	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	thumbnail.set_scale( scale )
	thumbnail.set_pos( get_size( ) / 2 )
	
	
	alpha_tween.interpolate_property( thumbnail, "visibility/self_opacity", \
		0, 1, 3, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	alpha_tween.start( )



func _on_mouse_enter():
	
	color_tween.interpolate_property( thumbnail, "modulate", \
		thumbnail.get_modulate( ), hovered_color, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	color_tween.start( )


func _on_mouse_exit():
	
	color_tween.interpolate_property( thumbnail, "modulate", \
		thumbnail.get_modulate( ), normal_color, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	color_tween.start( )
