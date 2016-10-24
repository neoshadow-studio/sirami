### @class DataStream
###
### @brief Base class for every class which saves and loads raw data.
###


extends Reference



### @brief Create a new instance.
###
func _init( ).( ):
	
	pass




### @brief Write the given data.
###
### @note This method must be overloaded by children classes.
###
### @param data : The raw data to write.
###
### @return `OK` if the write was successful, `ERR_*` or `FAILED` otherwise.
###
func write( data ):
	
	printerr( "DataStream.save : Unimplemented method." )
	
	return FAILED


### @brief Read some data.
###
### @note This method must be overloaded by children classes.
###
### @return The readed data, or `null` if the read failed.
###
func read( ): 

	printerr( "DataStream.load : Unimplemented method." )
	
	return null