
extends Sprite


func _on_anim_finished( ):
	
	queue_free( )
	get_parent( ).remove_child( self )

