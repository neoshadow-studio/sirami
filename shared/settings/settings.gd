
extends Node


const IniStream = preload( "res://data/ini_stream.gd" )



var settings = {
	"playfield": {
		"hide_background": false,
		"hide_sirami": false
	},
	
	"audio": {
		"global_volume": 1,
		"samples_volume": 1,
		"music_volume": 1
	}
}


func _ready( ):
	
	var ini = IniStream.new( "user://settings.ini" )
	ini.namespace = "settings"
	
	var data = ini.read( )
	
	if data != null:
		
		settings = data


func _exit_tree( ):
	
	var ini = IniStream.new( "user://settings.ini" )
	ini.namespace = "settings"
	
	ini.write( settings )


func get_setting( section, name, def=null ):
	
	if not settings.has( section ):
		
		if def != null:
			set_setting( section, name, def )
		
		return def
	
	if not settings[ section ].has( name ):
		
		if def != null:
			set_setting( section, name, def )
		
		return def
	
	return settings[ section ][ name ]


func set_settings( section, name, value ):
	
	if not settings.has( section ):
		
		settings[ section ] = { }
	
	settings[ section ][ name ] = value