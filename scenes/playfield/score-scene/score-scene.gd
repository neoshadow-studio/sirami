### @class ScoreScene
###
### @brief The score scene.
###



extends Container




const TrackSelect = preload( "res://scenes/track_select/track_select.tscn" )




### @brief The scene switcher singleton.
onready var scene_switcher = get_node( "/root/scene_switcher" )
### @brief The background singleton.
onready var background = get_node( "/root/background" )

### @brief The title label.
onready var n_title = get_node( "title" )
### @brief The artiste label.
onready var n_artist = get_node( "artist" )
### @brief The name label.
onready var n_name = get_node( "name" )
### @brief The mapper label.
onready var n_mapper = get_node( "mapper" )
### @brief The score label.
onready var n_score = get_node( "score" )

### @brief The accuracy label.
onready var n_accuracy = get_node( "scores/accuracy/value" )
### @brief The number of 100 obtained label.
onready var n_played_100 = get_node( "scores/100/value" )
### @brief The number of 50 obtained label.
onready var n_played_50 = get_node( "scores/50/value" )
### @brief The number of 10 obtained label.
onready var n_played_10 = get_node( "scores/10/value" )
### @brief The number of miss label.
onready var n_missed = get_node( "scores/miss/value" )
### @brief The max combo label.
onready var n_max_combo = get_node( "scores/max_combo/value" )

### @brief The scores dictionary.
var scores
### @brief The track data.
var track

### @brief The values' tween.
var tween

### @brief The showed score.
var score = 0
### @brief The showed accuracy.
var acc = 0
### @brief The showed number of 100 obtained.
var p_100 = 0
### @brief The showed number of 50 obtained.
var p_50 = 0
### @brief The showed number of 10 obtained.
var p_10 = 0
### @brief The showed number of miss.
var missed = 0
### @brief The showed max combo.
var max_combo = 0




### @brief Called when the node is ready in the tree.
###
func _ready():
	
	# We create the tween.
	tween = Tween.new( )
	add_child( tween )
	
	# We set the text labels.
	n_title.set_text( track.metadata.title )
	n_artist.set_text( track.metadata.artist )
	n_name.set_text( track.metadata.name )
	n_mapper.set_text( track.metadata.mapper )
	
	# We enable the process and the input process.
	set_process( true )
	set_process_input( true )
	
	# We start the coroutine.
	show_score( )




### @brief Updates the score scene.
###
### @param dt : The delta-time.
###
func _process( dt ):
	
	# We updates all the value's label.
	n_score.set_text( "%09d" % score )
	n_accuracy.set_text( "%d" % (acc*100) )
	n_played_100.set_text( "%d" % p_100 )
	n_played_50.set_text( "%d" % p_50 )
	n_played_10.set_text( "%d" % p_10 )
	n_missed.set_text( "%d" % missed )
	n_max_combo.set_text( "%dx" % max_combo )




### @brief Called when an input event is received.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If the left click is pressed
	if ev.type == InputEvent.MOUSE_BUTTON and ev.button_index == BUTTON_LEFT and ev.is_pressed( ):
		
		# We stop the tween.
		tween.stop_all( )
		
		# We set all the showed value to their maximums
		score = scores.score
		acc = scores.accuracy
		p_100 = scores[ "100" ]
		p_50 = scores[ "50" ]
		p_10 = scores[ "10" ]
		missed = scores.missed
		max_combo = scores.combo




### @brief Show the score.
###
### This is a corouting that update all the showed values.
###
func show_score( ):
	
	# We ease the showed score.
	tween.interpolate_property( self, "score", 0, scores.score, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start( )
	yield( tween, "tween_complete" )
	
	# We ease the showed accuracy.
	tween.interpolate_property( self, "acc", 0, scores.accuracy, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start( )
	yield( tween, "tween_complete" )
	
	# If there are at least one 100
	if scores[ "100" ] != 0:
		
		# We ease the showed number of 100 obtained.
		tween.interpolate_property( self, "p_100", 0, scores[ "100" ], 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	# If there are at least one 50
	if scores[ "50" ] != 0:
	
		# We ease the showed number of 50 obtained.
		tween.interpolate_property( self, "p_50", 0, scores[ "50" ], 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	# If there are at least one 10
	if scores[ "10" ] != 0:
	
		# We ease the showed number of 10 obtained.
		tween.interpolate_property( self, "p_10", 0, scores[ "10" ], 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	# If there are at least one miss
	if scores.missed != 0:
	
		# We ease the showed number of miss
		tween.interpolate_property( self, "missed", 0, scores.missed, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	# We ease the showed max combo.
	tween.interpolate_property( self, "max_combo", 0, scores.combo, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start( )
	yield( tween, "tween_complete" )




### @brief Signal: `quit.pressed`
###
func _on_quit_pressed():
	
	# We create the track selection scene
	var ins = TrackSelect.instance( )
	
	# We load the default background
	var tex = preload( "res://resources/images/main_background.tex" )
	# Set it and show the sirami logo.
	background.define( tex )
	background.show_logo( )
	
	# We stop the music if it is still playing.
	get_node( "/root/music" ).stop( )
	
	# And switch to this scene.
	scene_switcher.switch_with_fade( self, ins )
