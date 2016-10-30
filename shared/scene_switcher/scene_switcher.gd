
extends Node


var old_scene
var new_scene

onready var n_bg = get_node( "background" )


func _ready():
	
	pass



func set_transition_background( tex, color ):
	
	if tex == null:
		return
	
	n_bg.set_texture( tex )
	n_bg.set_modulate( color )
	
	n_bg.set_pos( get_viewport( ).get_rect( ).size / 2 )
	
	var scale = get_viewport( ).get_rect( ).size / tex.get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	n_bg.set_scale( scale )
	n_bg.show( )


func remove_transition_background( ):
	
	n_bg.hide( )
	n_bg.set_texture( null )


func get_transition_background( ):
	
	return n_bg.get_texture( )



func switch_with_fade( old_scene, new_scene ):
	
	self.old_scene = old_scene
	self.new_scene = new_scene
	
	
	var t1 = Tween.new( )
	var t2 = Tween.new( )
	
	old_scene.add_child( t1 )
	old_scene.add_child( t2 )
	
	t1.interpolate_property( old_scene, "visibility/opacity", 1, 0, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT )
	t2.interpolate_property( new_scene, "visibility/opacity", 0, 1, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5 )
	
	t1.start( )
	t2.start( )
	
	t2.connect ( "tween_complete", self, "on_fade_tween_finished" )
	
	get_tree( ).get_root( ).add_child( new_scene )
	new_scene.set_opacity( 0 )




func on_fade_tween_finished( a, b ):
	
	if new_scene.has_method( "_scene_transition_finished" ):
		
		new_scene._scene_transition_finished( old_scene )
	
	old_scene.queue_free( )
	get_tree( ).get_root( ).remove_child( old_scene )
	
	old_scene = null
	new_scene = null
	
	remove_transition_background( )
