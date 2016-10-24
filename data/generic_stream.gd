### @class GenericStream
###
### @brief Data stream implementation with Godot's File class.
###


extends "res://data/data_stream.gd"


### @brief The path to the file.
###
var path




### @brief Create a new instance.
###
### @param path : The path to the file.
###
func _init( path ).( ):
	
	self.path = path




### @brief Write the given data.
###
### @param data : The raw data to write.
###
### @return `OK` if the write was successful, `ERR_*` or `FAILED` otherwise.
###
func write( data ):
	
	var file = File.new( )
	
	if file.open( path, File.WRITE ) != OK:
		
		printerr( "Can't open file '" + path + "'." )
		return FAILED
	
	file.store_var( data )
	file.close( )
	
	return OK




### @brief Read some data.
###
### @return The readed data, or `null` if the read failed.
###
func read( ):
	
	var file = File.new( )
	
	if file.open( path, File.READ ) != OK:
		
		printerr( "Can't open file '" + path + "'." )
		return null
	
	var data = file.get_var( )
	file.close( )
	
	return data