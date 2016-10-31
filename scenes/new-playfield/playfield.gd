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




### @brief The settings manager.
var settings
### @brief The clocks manager.
var clocks
### @brief The music manager.
var music
### @brief The notifications manager.
var notifications
### @brief The background manager.
var background

### @brief The track to play.
var track = null

### @brief The visual part.
var visual
### @brief The audio part.
var audio
### @brief The logical part.
var logical
### @brief The time part.
var time
### @brief The transition part.
var transition
### @brief The score part.
var score
### @brief The notes part.
var notes
### @brief The timed objects part.
var timed_objects
### @brief The gui part.
var gui
### @brief The input part.
var input
### @brief The mods part.
var mods




### @brief Called when the node is ready in the scene.
###
func _ready( ):
	
	# We load the singletons
	settings = get_node( "/root/settings" )
	clocks = get_node( "/root/clocks" )
	music = get_node( "/root/music" )
	notifications = get_node( "/root/notifications" )
	background = get_node( "/root/background" )
	
	# If there are no tracks
	if track == null:
		
		# We show a notification and stop here
		notifications.spawn_basic( "No tracks given." )
		return
	
	
	# We load the different parts of the scene.
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
	
	# We enable the process, the fixed process, and the input handling
	set_process( true )
	set_fixed_process( true )
	set_process_input( true )




### @brief Updates the scene.
###
### @param dt : The delta-time.
###
func _process( dt ):
	
	# We let the logical part do this.
	logical.process( dt )


### @brief Updates the scene at a fixed step.
###
### @param dt : The delta-time.
###
func _fixed_process( dt ):
	
	# We let the logical part do this.
	logical.fixed_process( dt )


### @brief Called when a input event is received.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# We let the logical part handle the event.
	logical.input( ev )