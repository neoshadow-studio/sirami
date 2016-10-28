
extends GridContainer

const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )
const TrackItem = preload( "res://scenes/track_select/track-item/track-item.tscn" )
const Playfield = preload( "res://scenes/playfield/playfield.tscn" )


onready var database = get_node( "/root/database" ) 


var loading_list = []
var threads = []


func _ready():
	
	get_tree( ).connect( "screen_resized", self, "on_screen_resized" )
	
	for track in database.database:
		
		var ins = TrackItem.instance( )
		
		loading_list.push_back( track.thumbnail )
		
		ins.track_path = track.path
		
		ins.title = track.title
		ins.artist = track.artist
		ins.name = track.name
		
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



func load_track( path ):
	
	var ini = IniStream.new( path )
	ini.namespace = "track"
	
	var data = ini.read( )
	
	if data == null:
		
		printerr( "Can't load track from '" + path + "' !" )
		return
	
	
	var track = Track.from_data( data )
	track.base_dir = path.get_base_dir( )
	
	var pf = Playfield.instance( )
	
	pf.track = track
	
	var root = get_tree( ).get_root( )
	var scene = root.get_child( root.get_child_count( ) - 1 )
	
	var t1 = Tween.new( )
	var t2 = Tween.new( )
	
	add_child( t1 )
	add_child( t2 )
	
	finish_threads( )
	
	t2.connect( "tween_complete", self, "on_tweens_finished" )
	
	pf.set_opacity( 0 )
	
	t1.interpolate_property( scene, "visibility/opacity", 1, 0, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT )
	t2.interpolate_property( pf, "visibility/opacity", 0, 1, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5 )
	
	t1.start( )
	t2.start( )
	
	root.add_child( pf )



func on_tweens_finished( a, b ):
	
	var root = get_tree( ).get_root( )
	var scene = root.get_child( root.get_child_count( ) - 2 )
	
	scene.queue_free( )
	root.remove_child( scene )