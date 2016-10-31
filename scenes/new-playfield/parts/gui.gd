### @class Part_Gui
###
### @brief Manage the gui.
###



extends Reference




### @brief The playfield.
var playfield

### @brief The score label.
var score
### @brief The accuracy label.
var accuracy
### @brief The combo label.
var combo

### @brief The showed score.
var showed_score = 0




### @brief Initialize a new instance.
###
### @param pf : The playfield
###
func _init( pf ):
	
	playfield = pf
	
	# We get the gui nodes.
	score = playfield.get_node( "high-gui/score" )
	accuracy = playfield.get_node( "high-gui/accuracy" )
	combo = playfield.get_node( "high-gui/combo" )
	
	# We connect the score's signals
	playfield.score.connect( "score_changed", self, "_on_score_changed" )
	playfield.score.connect( "combo_lost", self, "_on_combo_lost" )
	
	# We do a first update.
	_on_score_changed( )




### @brief Updates the gui.
###
func process( dt ):
	
	score.set_text( "%09d" % showed_score )




### @brief Signal: `score.score_changed`
###
func _on_score_changed( ):
	
	# We get the score tween.
	var tween = score.get_node( "tween" )
	
	# We stop it
	tween.stop_all( )
	
	# We setup the tween
	tween.interpolate_property( self, "showed_score", showed_score, playfield.score.score, \
		0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT )
	
	# and we restart it
	tween.start( )
	
	
	# We play the combo increase animation
	var anim = combo.get_node( "animation" )
	anim.play( "increase" )
	
	
	# And set the accuracy and combo label.
	accuracy.set_text( "%d" % ( playfield.score.accuracy * 100 ) )
	combo.set_text( "%dx" % playfield.score.combo )




### @brief Signal: `score.combo_lost`
###
func _on_combo_lost( ):
	
	# We start the combo lost animation
	var anim = combo.get_node( "animation" )
	anim.play( "miss" )
	
	# We reset the text of the combo and update the text of the accuracy
	combo.set_text( "0x" )
	accuracy.set_text( "%d" % ( playfield.score.accuracy * 100 ) )

