### @class Track
###
### @brief Track data.
###



extends Reference




const TimedObject = preload( "res://shared/timed_object/timed_object.gd" )
const BasicNote = preload( "res://scenes/playfield/notes/basic_note.gd" )




### @brief The metadata of the track.
var metadata = {
	"title": "",
	"artist": "",
	"name": "",
	"mapper": ""
}

### @brief The difficulty settings of the track.
var difficulty = {
	"speed": 1,
	"size": 1,
	"timing_factor": 1
}

### @brief The file paths of the track.
var files = {
	"music": "",
	"background": "",
	"thumbnail": ""
}

### @brief The base directory of the track.
var base_dir = ""

### @brief The notes of the track.
var notes = []
### @brief The timed objects of the track.
var timed_objects = []




### @brief Create a new instance from loaded data.
###
### @param data : The loaded data.
### @return The new instance, or null.
###
static func from_data( data ):
	
	# We check if all the fields exist.
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
	
	# We create a new instance.
	var ins = new( )
	
	# We setup the basic fields.
	ins.metadata = data.metadata
	ins.difficulty = data.difficulty
	ins.files = data.files
	
	# We load the notes.
	for n in data.notes:
		ins.notes.push_back( BasicNote.from_data( n ) )
	
	# We load the timed objects.
	for to in data.timed_objects:
		
		ins.timed_objects.push_back( TimedObject.from_data( to ) )
	
	# We return the new instance.
	return ins




### @brief Converts the instance into savable data.
###
### @return Raw data.
###
func to_data( ):
	
	# We create two array for the raw data
	var notes_data = []
	var timed_object_data = []
	
	# We converts the notes to raw data
	for n in notes:
		notes_data.push_back( n.to_data( ) )
	
	# We converts the timed objects to raw data.
	for to in timed_objects:
		timed_objects.push_back( to.to_data( ) )
	
	# We returns the raw data.
	return {
		"metadata": metadata,
		"difficulty": difficulty,
		"files": files,
		"notes": notes_data,
		"timed_objects": timed_object_data
	}




### @brief Get the full path of the background.
###
func background_path( ):
	
	return base_dir + "/" + files.background


### @brief Get the full path of the thumbnail.
###
func thumbnail_path( ):
	
	return base_dir + "/" + files.thumbnail


### @brief Get the full path of the music.
###
func music_path( ):
	
	return base_dir + "/" + files.music