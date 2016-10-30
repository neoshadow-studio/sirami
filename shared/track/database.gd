
extends Node


const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )


onready var notifications = get_node( "/root/notifications" )




var database = [ ]
var updated = false

var db_update_thread



signal database_updated( )




func _ready():
	
	var ini = IniStream.new( "user://database.ini" )
	
	ini.namespace = "tracks"
	
	var data = ini.read( )
	
	if data != null:
		
		database = data
	
	
	var dir = Directory.new( )
	
	if not dir.dir_exists( "user://tracks/" ):
		
		dir.make_dir( "user://tracks/" )
	
	if not dir.dir_exists( "user://records/" ):
		
		dir.make_dir( "user://records/" )
	
	
	update_database( )




func _exit_tree( ):
	
	save( )



func update_database( ):
	
	if db_update_thread != null:
		
		db_update_thread.wait_to_finish( )
	
	db_update_thread = Thread.new( )
	db_update_thread.start( self, "_update_database", null, Thread.PRIORITY_HIGH )




func _update_database( a ):
	
	var notif = notifications.spawn_basic( "Updating database...", 0 )
	var time = OS.get_ticks_msec()
	
	var dir = Directory.new( )
	
	var r = dir.open( "user://tracks/" )
	if r != OK:
	
		notif.dismiss( )
		notifications.spawn_basic( "Failed to update database '%d'." % r )
		
		return
	
	if not dir.list_dir_begin( ):
		
		#notif.dismiss( )
		#notifications.spawn_basic( "Failed to update database 'list_dir_begin'." )
		
		#return
		pass
	
	
	var entry = dir.get_next( )
	
	while entry != "":
		
		if dir.current_is_dir( ) and entry != "." and entry != "..":
			
			var path = dir.get_current_dir( ) + "/" + entry
			var track_dir = Directory.new( )
			
			if track_dir.open( path ) == OK:
				
				_update_dir( track_dir )
		
		entry = dir.get_next( )
	
	
	dir.list_dir_end( )
	
	var tmp = []
	
	for i in range( database.size( ) ):
		
		var path = database[ i ].path
		
		if not dir.file_exists( path ):
			
			tmp.push_back( i )
	
	
	tmp.sort( )
	
	for i in range( tmp.size( ) ):
		
		database.remove( tmp[ i ] - i )
	
	notif.dismiss( )
	notifications.spawn_basic( "Database updated." )
	
	updated = true
	
	call_deferred( "emit_signal", "database_updated" )




func _update_dir( dir ):
	
	if not dir.list_dir_begin( ):
		
		#return
		pass
	
	
	var entry = dir.get_next( )
	
	while entry != "":
		
		if entry.extension( ) == "track":
			
			var path = dir.get_current_dir( ) + "/" + entry
			
			if has_entry( path ):
				
				entry = dir.get_next( )
				continue
			
			call_deferred( "add_db_entry", path )
		
		entry = dir.get_next( )


func add_db_entry( path ):
	
	var ini = IniStream.new( path )
	ini.namespace = "track"
	
	var data = ini.read( )
	
	var track = Track.from_data( data )
	
	if track == null:
		
		return
	
	
	var entry = { }
	
	entry.artist = track.metadata.artist
	entry.background = track.files.background
	entry.mapper = track.metadata.mapper
	entry.music = track.files.music
	entry.name = track.metadata.name
	entry.path = path
	entry.preview_time = track.files.preview_time
	entry.records = [ ]
	entry.thumbnail = track.files.thumbnail
	entry.title = track.metadata.title
	
	database.push_back( entry )




func has_entry( path ):
	
	for ent in database:
		
		if ent.path == path:
			
			return true
	
	return false



func save( ):
	
	var ini = IniStream.new( "user://database.ini" )
	
	ini.namespace = "tracks"
	
	ini.write( database )
