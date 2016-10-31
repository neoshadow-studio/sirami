### @class Playfield
###
### @brief The main gameplay scene.
###
### Before switching to this scene, the `track` field must
### be set to a valid track data.
###


extends Control



const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )

const Part_Visual = preload( "parts/visual.gd" )
const Part_Audio = preload( "parts/audio.gd" )
const Part_Logical = preload( "parts/logical.gd" )
const Part_Time = preload( "parts/time.gd" )
const Part_Transition = preload( "parts/transition.gd" )
const Part_Score = preload( "parts/score.gd" )
const Part_Notes = preload( "parts/notes.gd" )
const Part_TimedObjects = preload( "parts/timed_objects.gd" )
const Part_Gui = preload( "parts/gui.gd" )
const Part_Input = preload( "parts/input.gd" )
const Part_Mods = preload( "parts/mods.gd" )



var settings
var clocks
var music
var notifications


var track = null

var visual
var audio
var logical
var time
var transition
var score
var notes
var timed_objects
var gui
var input
var mods




func _ready( ):
	
	settings = get_node( "/root/settings" )
	clocks = get_node( "/root/clocks" )
	music = get_node( "/root/music" )
	notifications = get_node( "/root/notifications" )
	
	var ini = IniStream.new( "user://tracks/TestMusic/test.track" )
	ini.namespace = "track"
	
	track = ini.read( )
	track = Track.from_data( track )
	track.base_dir = "user://tracks/TestMusic"
	
	
	if track == null:
		
		notifications.spawn_basic( "Failed to load track." )
		return
	
	
	time = Part_Time.new( self )
	notes = Part_Notes.new( self )
	visual = Part_Visual.new( self )
	audio = Part_Audio.new( self )
	logical = Part_Logical.new( self )
	transition = Part_Transition.new( self )
	score = Part_Score.new( self )
	timed_objects = Part_Notes.new( self )
	gui = Part_Gui.new( self )
	input = Part_Input.new( self )
	mods = Part_Mods.new( self )
	
	set_process( true )
	set_fixed_process( true )
	set_process_input( true )




func _process( dt ):
	
	logical.process( dt )


func _fixed_process( dt ):
	
	logical.fixed_process( dt )


func _input( ev ):
	
	logical.input( ev )