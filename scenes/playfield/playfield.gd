
extends Container


const ScoreManager = preload( "res://scenes/playfield/score_manager.gd" )
const TimedObjectManager = preload( "res://scenes/playfield/timed_object_manager.gd" )
const Track = preload( "res://shared/track/track.gd" )

const Ini = preload( "res://data/ini_stream.gd" )

onready var clocks = get_node( "/root/clocks" )
onready var settings = get_node( "/root/settings" )

onready var background = get_node( "background" )
onready var sirami = get_node( "sirami" )
onready var low_fx = get_node( "low-fx" )
onready var notes = get_node( "notes" )
onready var low_gui = get_node( "low-gui" )
onready var high_fx = get_node( "high-fx" )
onready var high_gui = get_node( "high-gui" )

onready var samples = get_node( "samples" )
onready var music = get_node( "music" )

onready var timeline = get_node( "low-gui/timeline" )
onready var cursor = get_node( "low-gui/cursor" )

var score_manager
var timed_object_manager

var global_volume = 1
var samples_volume = 1
var current_samples_volume = 1
var music_volume = 1


var track

var timeline_visual_offset = 0
var timeline_time_offset setget , get_timeline_time_offset

var time_offset = 0.82



func _ready():
	
	timeline_visual_offset = timeline.get_scale( ).x * timeline.get_texture( ).get_size( ).x
	
	clocks.add_clock( "music" )
	
	
	global_volume = settings.get_setting( "audio", "global_volume", 1 )
	samples_volume = settings.get_setting( "audio", "samples_volume", 1 )
	music_volume = settings.get_setting( "audio", "music_volume", 1 )
	
	music.set_volume( global_volume * music_volume )
	
	
	music.set_stream( load( track.base_dir + "/" + track.files.music ) )
	music.play( )
	
	
	score_manager = ScoreManager.new( self )
	timed_object_manager = TimedObjectManager.new( self )
	
	
	background.initialize( self )
	sirami.initialize( self )
	low_fx.initialize( self )
	notes.initialize( self )
	timeline.initialize( self )
	cursor.initialize( self )
	high_fx.initialize( self )
	high_gui.initialize( self )
	music.initialize( self )
	
	
	if settings.get_setting( "playfield", "hide_background", false ):
	
		background.queue_free( )
		remove_child( background )
		
	if settings.get_setting( "playfield", "hide_sirami", false ):
		
		sirami.queue_free( )
		remove_child( sirami )
	





func get_timeline_time_offset( ):
	
	return timeline_visual_offset / notes.speed


func get_time( ):
	
	return clocks.get_time( "music" )


func set_time( v ):
	
	clocks.set_time( "music", v )



func play_samples( smpls, vol = null ):
	
	var voice
	
	
	if (smpls & 0x01) != 0:
		
		voice = samples.play( "normal" )
	
	if (smpls & 0x02) != 0:
		
		voice = samples.play( "clap" )
	
	if (smpls & 0x04) != 0:
		
		voice = samples.play( "finish" )
		
	if (smpls & 0x08) != 0:
		
		voice = samples.play( "whistle" )
	
	
	if not voice:
		
		return
	
	
	if vol: 
		
		samples.set_volume( voice, global_volume * samples_volume * vol )
	
	else:
		
		samples.set_volume( voice, global_volume * samples_volume * current_samples_volume )