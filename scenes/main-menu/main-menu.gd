### @class MainMenu
###
### @brief The main menu scene.
###



extends Container




### @brief The sirami logo.
var logo




### @brief Called when the transition is finished.
###
func _scene_transition_finished( os ):
	
	# We get the sirami logo node.
	var sl = get_node( "/root/background/sirami-logo" )
	
	# We disconnect the resize event.
	get_viewport( ).disconnect( "screen_resized", sl, "_on_parent_resized" )
	
	# We change the script of the logo
	sl.set_script( preload( "res://scenes/main-menu/sirami-logo.gd" ) )
	sl._ready( )

	# And keep a ref to it.
	logo = sl


