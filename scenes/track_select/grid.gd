
extends GridContainer

const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )
const TrackItem = preload( "res://scenes/track_select/track-item/track-item.tscn" )
const TrackOption = preload( "res://scenes/track_select/track-option/track-option.tscn" )
const Playfield = preload( "res://scenes/playfield/playfield.tscn" )


onready var database = get_node( "/root/database" ) 


var loading_list = []
var threads = []


func _ready():
	
	get_tree( ).connect( "screen_resized", self, "on_screen_resized" )
	
	for track in database.database:
		
		var ins = TrackItem.instance( )
		
		var path = track.path.get_base_dir( ) + "/" + track.thumbnail
		loading_list.push_back( path )
		
		ins.track_path = track.path
		ins.db_entry = track
		
		add_child( ins )
	
	
	for i in range( loading_list.size( ) ):
		
		var th = Thread.new( )
		th.start( self, "_load_thumbnail", i )
		
		threads.push_back( th )




func _load_thumbnail( index ):
	
	var path = loading_list[ index ]
	var item = get_child( index )
	
	var tex = load( path )
	item.on_thumbnail_loaded( tex )
	return null



func finish_threads( ):
	
	for th in threads:
		
		th.wait_to_finish( )



func on_screen_resized( ):
	
	var n = get_columns( )
	var width = 244 * n - 4
	
	
	if width + 20 > get_viewport_rect( ).size.x and n > 1:
		
		while width + 20 > get_viewport_rect( ).size.x:
			
			n -= 1
			width = 244 * n - 4
		
		set_columns( n )
	
	
	elif 244 * n - 4 < get_viewport_rect( ).size.x:
		
		while width + 20 < get_viewport_rect( ).size.x:
			
			n += 1
			width = 244 * n - 4
		
		set_columns( n - 1 )




func open_track_info( track ):
	
	var ins = TrackOption.instance( )
	ins.db_entry = track
	
	get_tree( ).get_root( ).add_child( ins )
