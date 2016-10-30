
extends Control

export( String, FILE, "*.tscn" ) var next_scene

export( float, 0, 360, 1 ) var start_angle = 0
export( float, 0, 360, 1 ) var end_angle = 0


var logo

var hovered = false
var clicked = false


func _ready():
	
	logo = get_parent( ).logo
	
	set_process( true )
	set_process_input( true )




func _input( ev ):
	
	if ev.is_action_pressed( "click" ) and logo != null and logo.angle != null:
		
		if rad2deg( logo.angle ) > end_angle and rad2deg( logo.angle ) < start_angle and hovered:
			
			if next_scene.empty( ):
				
				get_tree( ).quit( )
				return
			
			var scene = load( next_scene )
			
			if scene == null:
				
				print( "Failed to load scene '" + next_scene + "' !" )
				return 
			
			var ins = scene.instance( )
			var p = get_parent( )
			var nph = get_node( "/root/node_placeholder" )
			
			var bg = get_node( "../background" )
			var sl = get_node( "../sirami-logo" )
			
			p.disconnect( "resized", sl, "_on_parent_resized" )
			
			p.remove_child( bg )
			p.remove_child( sl )
			
			#sl.set_script( preload( "res://scenes/intro/sirami-logo.gd" ) )
			#sl.set_factor( 1 )
			#sl.bg_texture = sl.get_texture( )
			
			nph.add_child( bg )
			nph.add_child( sl )
			
			scene_switcher.switch_with_fade( p, ins )




func _process( dt ):
	
	if clicked:
		
		set_process( false )
		return
	
	if logo == null:
		
		logo = get_parent( ).logo
		return
	
	if logo.distance < 0:
		
		if hovered:
			
			hovered = false
			get_node( "anim" ).play( "normal" )
		
		return
	
	
	if start_angle > end_angle:
		
		if rad2deg( logo.angle ) > end_angle and rad2deg( logo.angle ) < start_angle and not hovered:
			
			hovered = true
			get_node( "anim" ).play( "hovered" )
		
		if ( rad2deg( logo.angle ) < end_angle or rad2deg( logo.angle ) > start_angle ) and hovered:
			
			hovered = false
			get_node( "anim" ).play( "normal" )

