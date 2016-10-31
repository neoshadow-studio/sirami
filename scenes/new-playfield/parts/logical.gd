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
	
	# We connect the pressed signal of the skip button.
	playfield.get_node( "high-gui/skip" ).connect( "pressed", self, "_on_skip_button_pressed" )
	
	# If we need to hide the background.
	if settings.get_setting( "playfield", "hide_background", false ):
		# We remove the background
		playfield.background.remove( )
	
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
	
	# We update the skip button
	_update_skip_button( )
	
	
	# We update the gui
	playfield.gui.process( dt )
	
	# We update the mods
	playfield.mods.process( dt )


### @brief Updates the time sensitive logic.
###
### @param dt : The delta-time.
###
func fixed_process( dt ) :
	
	# We update the notes.
	playfield.notes.fixed_process( dt )
	
	# If the auto mod isn't actif
	if not playfield.mods.auto_mode:
		# We update the input manager
		playfield.input.fixed_process( dt )


### @brief Called when an input event is received.
###
### @param ev : The event.
###
func input( ev ):
	
	playfield.input.input( ev )




### @brief Set the cursor Y factor.
###
### @param factor : The new factor (0 - 1).
###
func set_cursor_pos( factor ):
	
	# If the factor is less than 0
	if factor < 0:
		# We clamp it to 0
		factor = 0
	
	# If the factor is more than 1
	if factor > 1:
		# We clamp it to 1
		factor = 1
	
	# We set the cursor position
	cursor_position = factor
	
	# And update its position and scale.
	_update_cursor_scale_and_pos( )




### @brief Checks if the skip button can be used.
###
### @return true if the skip button can be used.
###
func can_skip( ):
	
	# If there are no note
	if playfield.notes.list.size( ) == 0:
		# We returns false
		return false
	
	
	# If we are before the first note
	if playfield.time.get_time( ) < playfield.notes.get_first( ).time - 3:
		# We return true
		return true
	
	# If we are after the last note.
	if playfield.time.get_time( ) > playfield.notes.get_last( ).time + 1:
		# We return true
		return true
	
	# Otherwise we return false.
	return false


### @brief Skip to the next point.
###
### Before the first note, skip to 3 sec before the first note.
### After the first ndoe, skip to the score menu.
###
func skip( ):
	
	# If we are after the first note's time.
	if playfield.time.get_time( ) < playfield.notes.get_first( ).time:
		# We skip to 3 sec before the first note.
		playfield.music.play( playfield.notes.get_first( ).time - 3 )
	
	
	# TODO: Skip to score menu




### @brief Called when a key/button is pressed.
###
func on_key_pressed( ):
	
	# We apply the color effect on the cursor
	playfield.visual.apply_color_effect_on_cursor( )
	
	# We get the first alive note
	var first = playfield.notes.get_first_alive( )
	
	# If the cursor is in it and if it's playable
	if first != null and first.is_cursor_in( ) and playfield.score.can_be_played( first ):
		# We play it
		first.play( )



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
	# We update its Y position
	pos.y = playfield.get_size( ).y - ( cursor.get_texture( ).get_size( ).y * scale )
	pos.y = pos.y * cursor_position + ( cursor.get_texture( ).get_size( ).y * scale / 2 )
	
	# We tell the visual part to update the cursor scale and pos.
	playfield.visual.update_cursor_scale_and_pos( scale, pos )




### @brief Called when the scene transition is finished.
###
func on_scene_transition_finished( ):
	
	pass




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




### @brief Updates the skip button.
###
func _update_skip_button( ):
	
	# We get the skip button and the animation node
	var skip = playfield.get_node( "high-gui/skip" )
	var anim = skip.get_node( "animation" )
	
	# Can we skip ?
	var can_skip = self.can_skip( )
	
	# If we can start the show animation.
	if can_skip and not skip.is_visible( ) and not anim.is_playing( ):
		anim.play( "show" )
	
	# If we can start the hide animation;
	if not can_skip and skip.is_visible( ) and not anim.is_playing( ):
		anim.play( "hide" )


### @brief Signal: `high-gui/skip.pressed`
###
func _on_skip_button_pressed( ):
	
	# We skip
	skip( )