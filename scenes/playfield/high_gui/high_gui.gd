
extends Control


onready var score = get_node( "score" )
onready var combo = get_node( "combo" )
onready var accuracy = get_node( "accuracy" )

var displayed_score = 0

var score_tween
var combo_tween

var playfield


func _ready():
	
	score.set_text( "000000000" )
	combo.set_text( "0x")
	accuracy.set_text( "100" )
	
	score_tween = Tween.new( )
	combo_tween = Tween.new( )
	
	add_child( score_tween )
	add_child( combo_tween )
	
	set_process( true )



func initialize( pf ):
	
	playfield = pf


func _process( dt ):
	
	score.set_text( "%09d" % displayed_score )


func update_score( ):
	
	combo.set_text( "%dx" % playfield.score_manager.combo )
	accuracy.set_text( "%d" % floor( playfield.score_manager.accuracy*100 ) )
	
	score_tween.interpolate_property( self, "displayed_score", displayed_score, \
		playfield.score_manager.score, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN )
	score_tween.start( )
	
	
	if playfield.score_manager.combo != 0:
	
		combo_tween.interpolate_property( combo, "rect/scale", \
			Vector2(1, 2), Vector2(1, 1), 0.4, Tween.TRANS_CIRC, Tween.EASE_OUT )
		
	else:
		
		combo_tween.interpolate_property( combo, "custom_colors/font_color", \
			Color("ff2020"), Color(1,1,1), 0.4, Tween.TRANS_CIRC, Tween.EASE_IN )
		
	combo_tween.start( )