
extends Panel



var track_path
var db_entry

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
	
	if db_entry != null:
		
		get_node( "title" ).set_text( db_entry.title )
		get_node( "artist" ).set_text( db_entry.artist )
		get_node( "name" ).set_text( db_entry.name )
	
	else:
		
		get_node( "title" ).set_text( "No tracks" )
		get_node( "artist" ).set_text( "" )
		get_node( "name" ).set_text( "" )
		
		get_node( "title" ).set_align( Label.ALIGN_CENTER )
	
	
	set_process_input( true )




func _input_event( event ):
	
	if db_entry == null:
		
		return
	
	
	if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed( ) and event.button_index == BUTTON_LEFT:
		
		var m_pos = get_local_mouse_pos( )
		
		if get_rect( ).has_point( m_pos ):
			
			get_node( "../../../.." ).open_track_info( db_entry )



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
		0, 1, 2, Tween.TRANS_SINE, Tween.EASE_OUT )
	
	alpha_tween.start( )



func _on_mouse_enter():
	
	color_tween.interpolate_property( thumbnail, "modulate", \
		thumbnail.get_modulate( ), hovered_color, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	color_tween.start( )


func _on_mouse_exit():
	
	color_tween.interpolate_property( thumbnail, "modulate", \
		thumbnail.get_modulate( ), normal_color, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	color_tween.start( )
