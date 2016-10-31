### @class Part_Visual
###
### @brief Contains the visual update part of the playfield.
###



extends Reference



const SIRAMI_NORMAL_MODULATE = Color8( 60, 60, 60 )
const SIRAMI_PLAYED_MODULATE = Color8( 160, 160, 160 )

const ScoreMiss = preload( "../scores/score_miss.tscn" )




### @brief The playfield.
var playfield

### @brief Visual offset of the timeline.
var timeline_offset

### @brief The initial scale of the sirami logo.
var logo_scale
### @brief Scale of the scores indicators.
var scores_scale




### @brief Initialize a new instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf
	
	# We compute the visual offset of the timeline
	var timeline = pf.get_node( "low-gui/timeline" )
	timeline_offset = timeline.get_texture( ).get_size( ).x * timeline.get_scale( ).x
	
	# We compute the score indicators size
	var ins = ScoreMiss.instance( )
	scores_scale = ( timeline_offset * 0.4 ) / ins.get_region_rect( ).size.x
	# We remove the temporary instance we used.
	ins.free( )




### @rief Updates the progress scale and position.
###
### @param factor : The progress factor.
###
func update_progress( factor ):
	
	# We get the timeline and progress nodes.
	var timeline = playfield.get_node( "low-gui/timeline" )
	var progress = playfield.get_node( "low-gui/progress" )
	
	# We compute the new Y scale of the progress node.
	var scale = ( playfield.get_size( ).y * factor ) / timeline.get_texture( ).get_size( ).y
	# We compute the new Y position of the progress node.
	var y = playfield.get_size( ).y - timeline.get_texture( ).get_size( ).y * scale
	
	# We get the actual scale of the progress node
	var sc = progress.get_scale( )
	# And modify its Y component.
	sc.y = scale
	
	# We set the scale of the progress node and its position.
	progress.set_scale( sc )
	progress.set_pos( Vector2( 0, y ) )
	
	
	# We get the actual scale of the timeline
	scale = timeline.get_scale( )
	# We update its Y component
	scale.y = playfield.get_size( ).y / timeline.get_texture( ).get_size( ).y
	
	# And update the timeline scale.
	timeline.set_scale( scale )




### @brief Updates the Sirami logo scale and position.
###
### @param scale : The new scale of the Sirami logo.
###
func update_sirami_logo( scale ):
	
	# We get the node
	var sirami_logo = playfield.get_node( "sirami-logo" )
	
	# And update its scale and position.
	sirami_logo.set_scale( scale )
	sirami_logo.set_pos( playfield.get_size( ) / 2 )
	
	# We keep the initial scale of the sirami logo
	logo_scale = scale


### @brief Updates the cursor scale and pos.
###
### @param scale : The new scale factor.
### @param pos : The new position.
###
func update_cursor_scale_and_pos( scale, pos ):
	
	# We get the node
	var cursor = playfield.get_node( "low-gui/cursor" )
	
	# We set its scale and pos.
	cursor.set_scale( Vector2( scale, scale ) )
	cursor.set_pos( pos )




### @brief Apply the color effect on the sirami logo.
###
### @param intensity : The intensity.
###
func apply_color_tween_on_sirami_logo( intensity ):
	
	# We get the logo and the tween
	var logo = playfield.get_node( "sirami-logo" )
	var tween = logo.get_node( "color-tween" )
	
	# We compute the bright color
	var col = SIRAMI_NORMAL_MODULATE.linear_interpolate( SIRAMI_PLAYED_MODULATE, intensity )
	
	# We setup the tween
	tween.interpolate_property( logo, "modulate", col, \
		Color8( 80, 80, 80 ), 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT )
	
	# We start the tween.
	tween.start( )


### @brief Apply the scale effect on the sirami logo.
###
### @param intensity : The intensity.
###
func apply_scale_tween_on_sirami_logo( intensity ):
	
	# We get the logo and the tween.
	var logo = playfield.get_node( "sirami-logo" )
	var tween = logo.get_node( "scale-tween" )
	
	# We setup the tween.
	tween.interpolate_property( logo, "transform/scale", logo_scale * 1.5 * intensity, logo_scale, \
		0.2, Tween.TRANS_CIRC, Tween.EASE_OUT )
	
	# We start the tween.
	tween.start( )




### @brief Apply the bright effect on the cursor.
###
func apply_color_effet_on_cursor( ):
	
	# We just starts the animation player.
	playfield.get_node( "low-gui/cursor/animation" ).play( "click" )




### @brief Spawns a score at the given Y position.
###
### @param score_scene : The score packed scene.
### @param y_pos : The Y position of the score.
###
func spawn_score( score_scene, y_pos ):
	
	# We create a new instance.
	var ins = score_scene.instance( )
	var pos = Vector2( 0, 0 )
	
	# We define it's position.
	pos.x = timeline_offset - ( ins.get_region_rect( ).size.x * scores_scale / 2 ) - 64
	pos.y = y_pos
	
	# We set the scale and the position of the indicator.
	ins.set_scale( Vector2( scores_scale, scores_scale ) )
	ins.set_pos( pos )
	
	# We add it to the high FX node.
	playfield.get_node( "high-fx" ).add_child( ins )


### @brief Spawns a note FX.
###
### @param fx_scene : The FX packed scene.
### @param y_pos : The Y position of the FX.
###
func spawn_note_fx( fx_scene, y_pos, factor = 0.1, center = true ):
	
	# We create a new instance
	var ins = fx_scene.instance( )
	var pos = Vector2( 0, 0 )
	
	# We calculate the scale
	var scale = factor * playfield.get_size( ).y * playfield.track.difficulty.size / ins.get_texture( ).get_size( ).y
	
	
	# We define the position
	pos.x = timeline_offset
	pos.y = y_pos
	
	# If we don't center the FX on the timeline
	if not center:
		# We increase the X position
		pos.x += ins.get_texture( ).get_size( ).x * scale / 2
	
	
	# We define the scale and the position of the FX.
	ins.set_scale( Vector2( scale, scale ) )
	ins.set_pos( pos )
	
	# We add the FX to the low-fx node.
	playfield.get_node( "low-fx" ).add_child( ins )