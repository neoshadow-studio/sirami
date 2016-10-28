
extends Node


const IniStream = preload( "res://data/ini_stream.gd" )



var database = [
	{
		"path": "res://TestMusic/test.ini",
		"thumbnail": "res://TestMusic/background.jpg",
		
		"title": "What You Do",
		"artist": "The Queenstons",
		"name": "Preview",
		"mapper": "Linkpy"
	}
]



func _ready():
	
	var ini = IniStream.new( "user://database.ini" )
	
	ini.namespace = "tracks"
	
	var data = ini.read( )
	
	if data != null:
		
		database = data


func _exit_tree() :
	
	var ini = IniStream.new( "user://database.ini" )
	
	ini.namespace = "tracks"
	
	ini.write( database )





