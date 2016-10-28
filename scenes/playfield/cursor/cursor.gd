
extends Sprite


var playfield
var note_manager

var auto_mode = true
var y_pos = 0.5
var y_tween = null

var color_tween

var normal_color = Color8( 180,180,180 )
var pressed_color = Color8( 255, 255, 255 )



func _ready():
	
	y_tween = Tween.new( )
	add_child( y_tween )
	
	color_tween = Tween.new( )
	add_child( color_tween )
	
	y_tween.connect( "tween_complete", self, "on_y_tween_finished" )
	
	
	set_fixed_process( true )
	set_process_input( true )



func _fixed_process( dt ):
	
	if not auto_mode:
		
		_process_manual( dt )
	
	else:
		
		var pos = get_pos( )
		
		pos.y = playfield.get_size( ).y - ( get_texture( ).get_size( ).y * get_scale( ).x )
		pos.y = pos.y * y_pos + (get_texture( ).get_size( ).y * get_scale( ).x / 2)
		
		set_pos( pos )




func _process_manual( dt ):
	
	var mouse_y = get_global_mouse_pos( ).y
	
	
	if mouse_y < ( get_texture( ).get_size( ).y * get_scale( ).y ) / 2:
		
		mouse_y = ( get_texture( ).get_size( ).y * get_scale( ).y ) / 2
	
	elif mouse_y > playfield.get_size( ).y - ( get_texture( ).get_size( ).y * get_scale( ).y ) / 2:
		
		mouse_y = playfield.get_size( ).y - ( get_texture( ).get_size( ).y * get_scale( ).y ) / 2
	
	
	var pos = get_pos( )
	pos.y = mouse_y
	set_pos( pos )



func _input( event ):
	
	if ( event.is_action_pressed( "button_1" ) or event.is_action_pressed( "button_2" ) ) and not auto_mode:
		
		color_tween.interpolate_property( self, "modulate", pressed_color, normal_color, \
			0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
		
		color_tween.start( )


func on_y_tween_finished( a, b ):
	
	if not playfield:
		
		y_tween.interpolate_property( self, "y_pos", \
			y_pos, y_pos, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT )
		
		y_tween.start( )
		return
	
	var notes = playfield.notes
	var note = notes.get_first( )
	
	if not note:
		
		y_tween.interpolate_property( self, "y_pos", \
			y_pos, 0.5, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT )
		
		y_tween.start( )
		return
	
	
	var duration = note.time - playfield.get_time( )
	
	if duration <= 0:
		
		y_tween.interpolate_property( self, "y_pos", \
			y_pos, y_pos, 0.01, Tween.TRANS_CIRC, Tween.EASE_OUT )
		
		y_tween.start( )
		return
	
	y_tween.interpolate_property( self, "y_pos", \
		y_pos, note.y_pos, duration, Tween.TRANS_CIRC, Tween.EASE_OUT )
	
	y_tween.start( )
	
	color_tween.interpolate_property( self, "modulate", pressed_color, normal_color, \
			0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT )
		
	color_tween.start( )
	


func initialize( pf ):
	
	playfield = pf
	note_manager = playfield.notes
	
	playfield.connect( "resized", self, "on_playfield_resized" )
	on_playfield_resized( )
	on_y_tween_finished( null, null )




func on_playfield_resized( ):
	
	var tex = get_texture( )
	var pf_size = playfield.get_size( )
	
	var scale = ( pf_size.y * 0.1 * note_manager.size ) / tex.get_size( ).y
	set_scale( Vector2( scale, scale ) )