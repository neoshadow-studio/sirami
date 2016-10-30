
extends Container


var logo

func _ready():
	pass



func _scene_transition_finished( os ):
	
	var nph = get_node( "/root/node_placeholder" )
	
	var sl = nph.get_node( "sirami-logo" )
	var bg = nph.get_node( "background" )
	
	get_parent( ).disconnect( "resized", sl, "_on_parent_resized" )
	
	nph.remove_child( sl )
	nph.remove_child( bg )
	
	sl.set_script( preload( "res://scenes/main-menu/sirami-logo.gd" ) )
	
	add_child( sl )
	add_child( bg )
	
	move_child( bg, 0 )
	move_child( sl, 1 )
	
	bg.set_z( -2 )
	sl.set_z( -1 )
	logo = sl


