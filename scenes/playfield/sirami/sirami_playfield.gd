
extends Sprite


var playfield

var scale_tween
var scale

var color_tween
var normal_color = Color8( 96, 96, 96 )
var note_color = Color8( 142, 142, 142 )


func _ready( ):
	
	scale_tween = Tween.new( )
	add_child( scale_tween )
	
	color_tween = Tween.new( )
	add_child( color_tween )


func initialize( pf ):

	playfield = pf
	
	playfield.connect( "resized", self, "on_playfield_resized" )
	playfield.notes.connect( "played", self, "on_note_played" )
	
	on_playfield_resized( )


func on_playfield_resized( ):
	
	var scale = ( 0.65 * playfield.get_size( ) ) / get_texture( ).get_size( )
	
	if scale.x < scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	self.scale = scale
	set_scale( scale )
	
	set_pos( playfield.get_size( ) / 2 )


func on_note_played( note ):
	
	if ( note.samples & 0x04 ) != 0 or ( note.samples & 0x08 ) !=0:
		
		scale_tween.interpolate_property( self, "transform/scale", \
			scale * 1.5, scale, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT )
		
		scale_tween.start( )
	
	color_tween.interpolate_property( self, "modulate", \
			note_color, normal_color, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	color_tween.start( )
