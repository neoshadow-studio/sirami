### @class Score
###
### @brief Script for score indicators.
###



extends Sprite




### @brief Called when the node enters the scene.
###
func _ready( ):
	
	# We randomly set the rotation from -15 to 15 degrees.
	set_rotd( rand_range( -15, 15 ) )




### @brief signal: `anim.finished`
func _on_anim_finished( ):
	
	# We remove the node
	queue_free( )
	get_parent( ).remove_child( self )
