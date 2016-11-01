### @class Part_Transition
###
### @brief Handles the scene transitons.
###



extends Reference



const TrackSelect = preload( "res://scenes/track_select/track_select.tscn" )
const ScoreScene = preload( "../score-scene/score-scene.tscn" )




### @brief The playfield.
var playfield




### @brief Initialize a new instance.
###
func _init( pf ):
	
	playfield = pf




### @brief Switch to the score scene.
###
func switch_to_score_scene( ):
	
	# We create a new instance and set its opacity to 0
	var ins = ScoreScene.instance( )
	ins.set_opacity( 0 )
	
	# We give to it the track instance
	ins.track = playfield.track
	# And give it the scores values.
	ins.scores = {
		"score": playfield.score.score,
		"combo": playfield.score.max_combo, 
		"accuracy": playfield.score.accuracy,
		
		"100": playfield.score.note_100_played,
		"50": playfield.score.note_50_played,
		"10": playfield.score.note_10_played,
		"missed": playfield.score.note_missed
	}
	
	
	# If we hide the background
	if playfield.settings.get_setting( "playfield", "hide_background", false):
		
		# We reload the texture
		var path = playfield.track.background_path( )
		var texture = load( path )
		
		# If the texture failed to load
		if not texture:
			# We show a notification.
			playfield.notifications.spawn_basic( "Can't load background : " + path )
		
		# If the texture is loaded
		else:
			# We define the background.
			playfield.background.define( texture )
	
	
	# We switch to the score menu.
	scene_switcher.switch_with_fade( playfield, ins )




### @brief Switch to the track selection.
###
func switch_to_track_select( ):

	# We create the track selection scene
	var ins = TrackSelect.instance( )
	
	# We load the default background
	var tex = preload( "res://resources/images/main_background.tex" )
	# Set it and show the sirami logo.
	playfield.background.define( tex )
	playfield.background.show_logo( )
	
	# We stop the music if it is still playing.
	playfield.music.stop( )
	
	# And switch to this scene.
	scene_switcher.switch_with_fade( playfield, ins )