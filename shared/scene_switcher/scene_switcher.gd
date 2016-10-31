### @class SceneSwitcher
###
### @brief Allow scene switches with effets.
###



extends Node




### @brief The old scene.
###
var old_scene

### @brief The new scene.
###
var new_scene




### @brief Switch to the new scene with a fade effect.
###
### @param old_scene : The old scene.
### @param new_scene : The new scene.
###
func switch_with_fade( old_scene, new_scene ):
	
	# We save the instances.
	self.old_scene = old_scene
	self.new_scene = new_scene
	
	# We create the fade tweens.
	var fade_tween = Tween.new( )
	
	# We add the tweens to the old scene
	old_scene.add_child( fade_tween )
	
	# We setup the tween
	fade_tween.interpolate_property( old_scene, "visibility/opacity", 1, 0, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT )
	fade_tween.interpolate_property( new_scene, "visibility/opacity", 0, 1, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5 )
	
	# We connect the tween_complete signal
	fade_tween.connect ( "tween_complete", self, "on_fade_tween_finished" )
	
	# We start the tween
	fade_tween.start( )
	
	# We add the new scene to the tree and set its opacity to 0
	get_tree( ).get_root( ).add_child( new_scene )
	new_scene.set_opacity( 0 )




### @brief Signal: `fade_tween.tween_complete`
###
func on_fade_tween_finished( obj, b ):
	
	# If the tween finished to update the opacity of the
	# new scene
	if obj == new_scene:
		
		# If the new scene has a callback method
		if new_scene.has_method( "_scene_transition_finished" ):
			# We call it
			new_scene._scene_transition_finished( old_scene )
		
		# We free the old scene.
		get_tree( ).get_root( ).remove_child( old_scene )
		old_scene.free( )
		
		# And we remove the references
		new_scene = null
		old_scene = null
