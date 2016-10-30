
extends Node


const MainMenu = preload( "res://scenes/main-menu/main-menu.tscn" )



onready var scene_switcher = get_node( "/root/scene_switcher" )

var exited = false


func _ready():
	
	connect( "resized", self, "_on_resized" )
	_on_resized( )
	
	set_process_input( true )




func _input( ev ):
	
	if ev.is_action_pressed( "click" ) and not exited:
		
		get_node( "anim" ).advance( 4 )




func _on_resized( ):
	
	var ns = get_node( "ns" )
	
	var pos = Vector2( 0, 0 )
	
	pos.x = get_size( ).x / 2
	pos.y = get_size( ).y - ns.get_texture( ).get_size( ).y * ns.get_scale( ).y / 2 - 16
	
	ns.set_pos( pos )




func _on_anim_finished( ):
	
	exited = true
	
	var ins = MainMenu.instance( )
	
	var bg = get_node( "background" )
	var sl = get_node( "sirami-logo" )
	
	disconnect( "resized", sl, "_on_parent_resized" )
	
	remove_child( bg )
	remove_child( sl )
	get_node( "/root/node_placeholder" ).add_child( bg )
	get_node( "/root/node_placeholder" ).add_child( sl )
	
	scene_switcher.switch_with_fade( self, ins )
