### @class MainMenu
###
### @brief The main menu scene.
###



extends Container




### @brief The sirami logo.
var logo




### @brief Called when the node is ready in the scene.
###
func _ready( ):
	
	# We enable the input process
	set_process_input( true )




### @brief Process the input event.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If the escape key is pressed
	if ev.is_action_pressed( "pause" ):
		# We quit
		get_tree( ).quit( )




### @brief Called when the transition is finished.
###
func _scene_transition_finished( os ):
	
	# We get the sirami logo node.
	var sl = get_node( "/root/background/sirami-logo" )
	
	# We change the script of the logo
	sl.set_script( preload( "res://scenes/main-menu/sirami-logo.gd" ) )
	sl._ready( )

	# And keep a ref to it.
	logo = sl


