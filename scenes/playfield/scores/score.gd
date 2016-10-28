
extends Sprite



func _ready( ):
	
	set_rotd( rand_range( -15, 15 ) )


func _on_anim_finished( ):
	
	queue_free( )
	get_parent( ).remove_child( self )
