
extends Container


const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )
const Playfield = preload( "res://scenes/playfield/playfield.tscn" )



onready var settings = get_node( "/root/settings" )
onready var scene_switcher = get_node( "/root/scene_switcher" )

onready var n_bg = get_node( "background" )
onready var n_title = get_node( "title" )
onready var n_artist = get_node( "artist" )
onready var n_name = get_node( "name" )
onready var n_mapper = get_node( "mapper" )

onready var n_duration = get_node( "duration" )
onready var n_music = get_node( "music" )

onready var n_auto_mode = get_node( "play_cont/auto_mode" )


var db_entry

var auto_mode = false
var back_pressed = false



func _ready():
	
	n_title.set_text( db_entry.title )
	n_artist.set_text( db_entry.artist )
	n_name.set_text( db_entry.name )
	n_mapper.set_text( db_entry.mapper )
	
	
	var tex = load( db_entry.path.get_base_dir( ) + "/" + db_entry.background )
	
	if not tex:
		
		printerr( "Failed to load background." )
	
	else:
		
		n_bg.set_texture( tex )
		
		connect( "resized", self, "on_resized" )
		on_resized( )
	
	
	var stream = load( db_entry.path.get_base_dir( ) + "/" + db_entry.music )
	
	if not stream:
		
		printerr( "Failed to load music." )
	
	else:
		
		n_music.set_stream( stream )
		n_music.play( db_entry.preview_time )
		
		var vol = settings.get_setting( "audio", "global_volume", 1 ) * settings.get_setting( "audio", "music_volume", 1 )
		n_music.set_volume( vol )
		
		var mins = int( n_music.get_length( ) / 60 )
		var seconds = int( n_music.get_length( ) - 60 * mins )
		
		n_duration.set_text( "Duration : %d:%d" % [mins, seconds] )



func on_resized( ):
		
	var scale = get_size( ) / n_bg.get_texture( ).get_size( )
	
	if scale.x > scale.y:
		
		scale.y = scale.x
	
	else:
		
		scale.x = scale.y
	
	n_bg.set_scale( scale )
	n_bg.set_pos( get_size( ) / 2 )



func on_auto_mode_pressed():
	
	auto_mode = not auto_mode


func _on_anim_finished():
	
	if back_pressed: 
		
		get_tree( ).get_root( ).remove_child( self )


func _on_back_pressed():
	
	back_pressed = true
	get_node( "anim" ).play( "fadeout" )
	
	var t = Tween.new( )
	add_child( t )
	
	t.interpolate_method( n_music, "set_volume", n_music.get_volume( ), 0, 0.6, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	t.start( )



func _on_play_pressed( ):
	
	var ini = IniStream.new( db_entry.path )
	ini.namespace = "track"
	
	var data = ini.read( )
	
	if data == null:
		
		printerr( "Can't load track from '" + db_entry.path + "' !" )
		return
	
	
	var track = Track.from_data( data )
	track.base_dir = db_entry.path.get_base_dir( )
	
	var pf = Playfield.instance( )
	
	pf.track = track
	pf.auto_mode = auto_mode
	
	pf.set_opacity( 0 )
	
	
	var root = get_tree( ).get_root( )
	var track_select = root.get_child( root.get_child_count( ) - 2 )
	
	track_select.finish_threads( )
	track_select.queue_free( )
	root.remove_child( track_select )
	
	var scene = root.get_child( root.get_child_count( ) - 1 )
	
	var t = Tween.new( )
	
	add_child( t )
	
	t.interpolate_method( n_music, "set_volume", n_music.get_volume( ), 0, 0.5, \
		Tween.TRANS_CUBIC, Tween.EASE_OUT )
	
	n_bg.hide( )
	
	t.start( )
	
	scene_switcher.set_transition_background( n_bg.get_texture( ), n_bg.get_modulate( ) )
	scene_switcher.switch_with_fade( scene, pf )




func on_tweens_finished( a, b ):
	
	call_deferred( "remove_self" )




func remove_self( ):
	
	var root = get_tree( ).get_root( )
	var scene = root.get_child( root.get_child_count( ) - 3 )
	var bg = root.get_child( root.get_child_count( ) - 2 )
	
	scene.queue_free( )
	bg.queue_free( )
	root.remove_child( scene )
	root.remove_child( bg )