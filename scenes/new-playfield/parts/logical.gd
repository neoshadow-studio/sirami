### @class Part_Logical
###
### @brief Contains the logic of the playfield.
###



extends Reference




const Score100 = preload( "../scores/score_100.tscn" )
const Score50 = preload( "../scores/score_50.tscn" )
const Score10 = preload( "../scores/score_10.tscn" )
const ScoreMiss = preload( "../scores/score_miss.tscn" )

const FxNormal = preload( "../notes-fx/fx_normal.tscn" )
const FxClap = preload( "../notes-fx/fx_clap.tscn" )
const FxFinish = preload( "../notes-fx/fx_finish.tscn" )
const FxWhistle = preload( "../notes-fx/fx_whistle.tscn" )




### @brief The playfield.
var playfield

### @brief Y position of the cursor.
var cursor_position = 0.5




### @brief Initialize the instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf
	
	playfield.connect( "resized", self, "_on_playfield_resized" )
	_on_playfield_resized( )
	
	# We connect the note played signal
	playfield.notes.connect( "played", self, "_on_note_played" )
	
	
	# If we need to hide the background.
	if settings.get_setting( "playfield", "hide_background", false ):
		# TODO: Hide the background.
		pass
	
	# If we need to hide the sirami logo.
	if settings.get_setting( "playfield", "hide_sirami", false ):
		# We hide the logo
		playfield.get_node( "sirami-logo" ).hide( )




### @brief Updates the logic.
###
### @param dt : The delta-time.
###
func process( dt ):
	
	# We update the timeline progression.
	_update_timeline_progress( )
	
	# We update the gui
	playfield.gui.process( dt )


### @brief Updates the time sensitive logic.
###
### @param dt : The delta-time.
###
func fixed_process( dt ) :
	
	# We update the notes.
	playfield.notes.fixed_process( dt )




### @brief Update the timeline progression.
###
func _update_timeline_progress( ):
	
	# If there are no music loaded
	if playfield.music.get_stream( ) == null or playfield.music.get_length( ) == 0:
		
		# We update the progress with a factor of 0
		playfield.visual.update_progress( 0 )
	
	
	# If there are a music loaded
	else:
		
		# We compute the factor
		var factor = playfield.time.get_time( ) / playfield.music.get_length( )
		
		# And tells the visual part to update the "progress" node.
		playfield.visual.update_progress( factor )




### @brief Signal: `playfield.resized`
###
func _on_playfield_resized( ):
	
	# We update the Sirami logo scale and position
	_update_sirami_logo( )
	# And the timeline progress.
	_update_timeline_progress( )
	
	# We update the cursor scale and position.
	_update_cursor_scale_and_pos( )
	
	# Replace the notes at their right position.
	playfield.notes.replace_notes( )


### @brief Updates the Sirami logo scale and position.
###
func _update_sirami_logo( ):
	
	# We get the sirami logo node
	var sirami_logo = playfield.get_node( "sirami-logo" )
	# Compute the temporary scale
	var scale = ( 0.65 * playfield.get_size( ) ) / sirami_logo.get_texture( ).get_size( )
	
	# We keep the aspect ratio
	if scale.x < scale.y:
		scale.y = scale.x
	
	else:
		scale.x = scale.y
	
	# And tells the visual part to update the scale and position.
	playfield.visual.update_sirami_logo( scale )


### @brief Updates the cursor scale and position.
###
func _update_cursor_scale_and_pos( ):
	
	# We get the cursor ndoe
	var cursor = playfield.get_node( "low-gui/cursor" )
	
	# We get the notes' size.
	var notes_size = playfield.track.difficulty.size
	# We compute its new scale.
	var scale = ( playfield.get_size( ).y * 0.1 * notes_size ) / cursor.get_texture( ).get_size( ).y
	
	# We get its current position
	var pos = cursor.get_pos( )
	# We update it's Y position
	pos.y = playfield.get_size( ).y - ( cursor.get_texture( ).get_size( ).y * cursor.get_scale( ).x )
	pos.y = pos.y * cursor_position + (cursor.get_texture( ).get_size( ).y * cursor.get_scale( ).x / 2)
	
	# We tell the visual part to update the cursor scale and pos.
	playfield.visual.update_cursor_scale_and_pos( scale, pos )




### @brief Signal: `notes.played`
###
func _on_note_played( note, score ):
	
	# The intensity of the effects
	var intensity = 1
	
	# If the note has a local volume
	if note.local_volume:
		intensity = note.volume
	
	# Otherwise, we use the global samples volume.
	else:
		intensity = playfield.audio.current_samples_volume
	
	
	# If the sirami logo isn't hide
	if not settings.get_setting( "playfield", "hide_sirami", false ):
		
		# We firstly apply the brighting effect on the logo
		playfield.visual.apply_color_tween_on_sirami_logo( intensity )
		
		
		# Then we apply the scaling effect on the logo
		# if the samples contains the Finish or the whistle sound.
		if ( note.samples & playfield.audio.SAMPLE_FINISH ) != 0:
			playfield.visual.apply_scale_tween_on_sirami_logo( intensity )
		
		elif ( note.samples & playfield.audio.SAMPLE_WHISTLE ) != 0:
			playfield.visual.apply_scale_tween_on_sirami_logo( intensity )
	
	
	# If this is a score of 100
	if score == 100:
		# we spawn a score indicator
		playfield.visual.spawn_score( Score100, note.get_pos( ).y )
	
	# If this is a score of 50
	if score == 50:
		# we spawn a score indicator
		playfield.visual.spawn_score( Score50, note.get_pos( ).y )
	
	# If this is a score of 10
	if score == 10:
		# we spawn a score indicator
		playfield.visual.spawn_score( Score10, note.get_pos( ).y )
	
	# If this is a miss
	if score == 0:
		# we spawn a score indicator
		playfield.visual.spawn_score( ScoreMiss, note.get_pos( ).y )
		return
	
	
	# If the note has the finish sample
	if ( note.samples & playfield.audio.SAMPLE_FINISH ) != 0:
		# We spawn an FX.
		playfield.visual.spawn_note_fx( FxFinish, note.get_pos( ).y, 0.3 )
	
	# If the note has the whistle sample
	elif ( note.samples & playfield.audio.SAMPLE_WHISTLE ) != 0:
		# We spawn an FX.
		playfield.visual.spawn_note_fx( FxWhistle, note.get_pos( ).y, 0.3 )
	
	# If the note has the clap sample
	elif ( note.samples & playfield.audio.SAMPLE_CLAP ) != 0:
		# We spawn an FX.
		playfield.visual.spawn_note_fx( FxClap, note.get_pos( ).y, 0.2, false )
	
	# If the has the normal sample
	elif ( note.samples & playfield.audio.SAMPLE_NORMAL ) != 0:
		# We spawn an FX.
		playfield.visual.spawn_note_fx( FxNormal, note.get_pos( ).y, 0.2, false )
	