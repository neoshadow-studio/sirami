
extends Container

const MainMenu = preload( "res://scenes/main-menu/main-menu.tscn" )
const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )
const TrackItem = preload( "res://scenes/track_select/track-item/track-item.tscn" )
const TrackOption = preload( "res://scenes/track_select/track-option/track-option.tscn" )
const Playfield = preload( "res://scenes/playfield/playfield.tscn" )


onready var database = get_node( "/root/database" ) 

onready var grid = get_node( "scroll/center/grid" )


var loading_list = []
var loading_thread

var exited = false


func _ready():
	
	get_tree( ).connect( "screen_resized", self, "on_screen_resized" )
	
	
	if not database.updated:
		
		database.connect( "database_updated", self, "_on_database_updated" )
	
	else:
		
		_on_database_updated( )
	
	
	if get_node( "/root/node_placeholder" ).get_child_count( ) == 0:
		
		get_node( "background" ).show( )
		get_node( "sirami-logo" ).show( )




func _scene_transition_finished( os ):
	
	var nph = get_node( "/root/node_placeholder" )
	
	if nph.get_child_count() == 0:
		return
	
	var sl = nph.get_node( "sirami-logo" )
	var bg = nph.get_node( "background" )

	nph.remove_child( sl )
	nph.remove_child( bg )
	
	get_node( "background" ).show( )
	get_node( "sirami-logo" ).show( )


func _load_thumbnails( a ):
	
	for i in range( loading_list.size( ) ):
		
		var n = grid.get_child( i )
		
		var tex = load( loading_list[ i ] )
		
		n.on_thumbnail_loaded( tex )




func _on_database_updated( ):
	
	if database.database.size( ) == 0:
		
		var ins = TrackItem.instance( )
		
		ins.db_entry = null
		
		grid.add_child( ins )
		return
	
	
	for track in database.database:
		
		var ins = TrackItem.instance( )
		
		var path = track.path.get_base_dir( ) + "/" + track.thumbnail
		loading_list.push_back( path )
		
		ins.track_path = track.path
		ins.db_entry = track
		
		grid.add_child( ins )
	
	
	loading_thread = Thread.new( )
	loading_thread.start( self, "_load_thumbnails" )




func finish_threads( ):
	
	loading_thread.wait_to_finish( )



func on_screen_resized( ):
	
	var n = grid.get_columns( )
	var width = 244 * n - 4
	
	
	if width + 20 > get_viewport_rect( ).size.x and n > 1:
		
		while width + 20 > get_viewport_rect( ).size.x:
			
			n -= 1
			width = 244 * n - 4
		
		grid.set_columns( n )
	
	
	elif 244 * n - 4 < get_viewport_rect( ).size.x:
		
		while width + 20 < get_viewport_rect( ).size.x:
			
			n += 1
			width = 244 * n - 4
		
		grid.set_columns( n - 1 )




func open_track_info( track ):
	
	var ins = TrackOption.instance( )
	ins.db_entry = track
	
	get_tree( ).get_root( ).add_child( ins )




func _on_back_pressed():
	
	if exited:
		return
	
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
