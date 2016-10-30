
extends Container


const TrackSelect = preload( "res://scenes/track_select/track_select.tscn" )


onready var scene_switcher = get_node( "/root/scene_switcher" )


onready var background = get_node( "background" )

onready var n_title = get_node( "title" )
onready var n_artist = get_node( "artist" )
onready var n_name = get_node( "name" )
onready var n_mapper = get_node( "mapper" )
onready var n_score = get_node( "score" )

onready var n_accuracy = get_node( "scores/accuracy/value" )
onready var n_played_100 = get_node( "scores/100/value" )
onready var n_played_50 = get_node( "scores/50/value" )
onready var n_played_10 = get_node( "scores/10/value" )
onready var n_missed = get_node( "scores/miss/value" )
onready var n_max_combo = get_node( "scores/max_combo/value" )


var scores
var track

var tween

var score = 0
var acc = 0
var p_100 = 0
var p_50 = 0
var p_10 = 0
var missed = 0
var max_combo = 0




func _ready():
	
	tween = Tween.new( )
	add_child( tween )
	
	n_title.set_text( track.metadata.title )
	n_artist.set_text( track.metadata.artist )
	n_name.set_text( track.metadata.name )
	n_mapper.set_text( track.metadata.mapper )
	
	set_process( true )
	set_process_input( true )
	
	show_score( )




func _process( dt ):
	
	n_score.set_text( "%09d" % score )
	n_accuracy.set_text( "%d" % (acc*100) )
	n_played_100.set_text( "%d" % p_100 )
	n_played_50.set_text( "%d" % p_50 )
	n_played_10.set_text( "%d" % p_10 )
	n_missed.set_text( "%d" % missed )
	n_max_combo.set_text( "%dx" % max_combo )




func _input( ev ):
	
	if ev.is_action_pressed( "button_1" ) or ev.is_action_pressed( "button_2" ) or ev.is_action_pressed( "skip" ):
		
		tween.stop_all( )
		
		score = scores.score
		acc = scores.accuracy
		p_100 = scores[ "100" ]
		p_50 = scores[ "50" ]
		p_10 = scores[ "10" ]
		missed = scores.missed
		max_combo = scores.combo




func show_score( ):
	
	tween.interpolate_property( self, "score", 0, scores.score, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start( )
	yield( tween, "tween_complete" )
	
	tween.interpolate_property( self, "acc", 0, scores.accuracy, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start( )
	yield( tween, "tween_complete" )
	
	if scores[ "100" ] != 0:
		
		tween.interpolate_property( self, "p_100", 0, scores[ "100" ], 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	if scores[ "50" ] != 0:
	
		tween.interpolate_property( self, "p_50", 0, scores[ "50" ], 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	if scores[ "10" ] != 0:
	
		tween.interpolate_property( self, "p_10", 0, scores[ "10" ], 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	if scores.missed != 0:
	
		tween.interpolate_property( self, "missed", 0, scores.missed, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
		tween.start( )
		yield( tween, "tween_complete" )
	
	tween.interpolate_property( self, "max_combo", 0, scores.combo, 1, Tween.TRANS_LINEAR, Tween.EASE_IN )
	tween.start( )
	yield( tween, "tween_complete" )




func _on_quit_pressed():
	
	var ins = TrackSelect.instance( )
	
	scene_switcher.switch_with_fade( self, ins )
