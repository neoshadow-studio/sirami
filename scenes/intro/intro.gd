### @class Intro
###
### @brief The intro scene.
###



extends Node




const MainMenu = preload( "res://scenes/main-menu/main-menu.tscn" )




### @brief The scen switcher singleton.
onready var scene_switcher = get_node( "/root/scene_switcher" )
### @brief The background singleton.
onready var background = get_node( "/root/background" )

### @brief Define if the scene exited.
var exited = false




### @brief Called when the node is in the scene.
###
func _ready():
	
	# We load the main background texture.
	var texture = load( "res://resources/images/main_background.tex" )
	
	
	# If we can't load the texture
	if not texture:
		# We show a notification	
		get_node( "/root/notifications" ).spawn_basic( "Unable to load default background." )
	
	# If the texture is loaded
	else:
		# We define the background texture.
		background.define( texture )
	
	
	# We connect the resized signal.
	connect( "resized", self, "_on_resized" )
	_on_resized( )
	
	# We enable the input process.
	set_process_input( true )




### @brief Called to handle input events.
###
### @param ev : The input event.
###
func _input( ev ):
	
	# If the event is a left button press
	if ev.type == InputEvent.MOUSE_BUTTON and ev.is_pressed( ) and ev.button_index == BUTTON_LEFT and not exited:
		# We advance the animation to finish it now.
		get_node( "anim" ).advance( 4 )




### @brief Signal: "self.resized"
###
func _on_resized( ):
	
	# We get the ns node
	var ns = get_node( "ns" )
	
	# We compute its new position
	var pos = Vector2( 0, 0 )
	pos.x = get_size( ).x / 2
	pos.y = get_size( ).y - ns.get_texture( ).get_size( ).y * ns.get_scale( ).y / 2 - 16
	
	# And set it.
	ns.set_pos( pos )




### @brief Signal: `anim.finished`
###
func _on_anim_finished( ):
	
	# We define the scene as exited
	exited = true
	
	# We create a new instance of the main menu
	var ins = MainMenu.instance( )
	
	# We get the sirami logo node
	var sl = get_node( "sirami-logo" )
	
	# We disconnect it.
	disconnect( "resized", sl, "_on_parent_resized" )
	
	# We remove it
	remove_child( sl )
	# And place it in the global place holder
	get_node( "/root/node_placeholder" ).add_child( sl )
	
	# We switch to the main menu.
	scene_switcher.switch_with_fade( self, ins )
