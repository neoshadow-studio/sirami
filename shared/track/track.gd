

extends Reference


const TimedObject = preload( "res://shared/timed_object/timed_object.gd" )
const BasicNote = preload( "res://scenes/playfield/notes/basic_note.gd" )




var metadata = {
	"title": "",
	"artist": "",
	"name": "",
	"mapper": ""
}

var difficulty = {
	"speed": 1,
	"size": 1,
	"timing_factor": 1
}

var files = {
	"music": "",
	"background": "",
	"thumbnail": ""
}

var base_dir = ""

var notes = []
var timed_objects = []



static func from_data( data ):
	
	if not data.has( "metadata" ):
		return null
	
	if not data.has( "difficulty" ):
		return null
	
	if not data.has( "files" ):
		return null
	
	if not data.has( "notes" ):
		return null
	
	if not data.has( "timed_objects" ):
		return null
	
	
	var ins = new( )
	
	ins.metadata = data.metadata
	ins.difficulty = data.difficulty
	ins.files = data.files
	
	for n in data.notes:
		
		ins.notes.push_back( BasicNote.from_data( n ) )
	
	for to in data.timed_objects:
		
		ins.timed_objects.push_back( TimedObject.from_data( to ) )
	
	return ins



func to_data( ):
	
	var notes_data = []
	var timed_object_data = []
	
	for n in notes:
		notes_data.push_back( n.to_data( ) )
	
	for to in timed_objects:
		timed_objects.push_back( to.to_data( ) )
	
	return {
		"metadata": metadata,
		"difficulty": difficulty,
		"files": files,
		"notes": notes_data,
		"timed_objects": timed_object_data
	}