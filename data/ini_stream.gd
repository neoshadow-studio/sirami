### @class IniStream
###
### @brief Data stream implementation using INI file.
###


extends "res://data/data_stream.gd"


### @brief The path of the INI file.
###
var path

### @brief The namespace of the data.
###
var namespace




### @brief Create a new instance.
###
### @param path : The INI file path.
###
func _init( path = null ).( ):
	
	self.path = path
	self.namespace = "data"




### @brief Write the given data.
###
### @param data : The raw data to write.
###
### @return `OK` if the write was successful, `ERR_*` or `FAILED` otherwise.
###
func write( data ):
	
	# If the instance wasn't configured
	if path == null or namespace == null:
		
		printerr( "Can't write INI data : invalid path and/or namespace." )
		return ERR_UNCONFIGURED
	
	# We only accept dictionaries and arrays.
	if typeof(data) != TYPE_DICTIONARY and typeof(data) != TYPE_ARRAY:
		
		printerr( "Raw data must be a Dictionary or an Array." )
		return ERR_INVALID_DATA
	
	# We create the ini and we write the data into it.
	var ini = ConfigFile.new( )
	_recursive_write( ini, self.namespace, data )
	
	# We returns the value of the save.
	return ini.save( self.path )




### @brief Read some data.
###
### @return The readed data, or `null` if the read failed.
###
func read( ): 
		
	# If the instance wasn't configured.
	if path == null or namespace == null:
		
		printerr( "Can't write INI data : invalid path and/or namespace." )
		return null
	
	# We create the ini file
	var ini = ConfigFile.new( )
	
	# We load it
	if ini.load( path ) != OK:
		
		printerr( "Failed to load INI file '" + path + "'." )
		return null
	
	# And return the loaded data.
	return _recursive_read( ini, namespace )




# Internal
func _recursive_write( ini, section, value ):
	
	if typeof(value) == TYPE_ARRAY:
		
		ini.set_value( section, "@is_array", true )
		ini.set_value( section, "length", value.size( ) )
		
		for i in range( value.size( ) ):
			
			var val = value[i]
			var key = "item-" + str(i+1)
		
			if typeof(val) == TYPE_ARRAY or typeof(val) == TYPE_DICTIONARY: 
	
				ini.set_value( section, key, "@nested" )
				_recursive_write( ini, section + "." + str(i+1), val )
				
			else:
				
				_write_value( ini, section, key, val )
		
	else:
		
		for key in value.keys( ):
			
			var val = value[key]
			
			if typeof(val) == TYPE_ARRAY or typeof(val) == TYPE_DICTIONARY:
				
				ini.set_value( section, key, "@nested" )
				_recursive_write( ini, section + "." + key, val )
			
			else:
				
				_write_value( ini, section, key, val )
			

# Internal
func _write_value( ini, section, key, val ):

	if typeof(val) == TYPE_STRING:
		
		ini.set_value( section, key, val.c_escape( ) )
	
	elif typeof(val) == TYPE_VECTOR2:
	
		var v = "@vector2 " + str(val.x) + ";" + str(val.y)
		ini.set_value( section, key, v )
	
	elif typeof(val) == TYPE_RECT2:
	
		var v = "@rect2 " + str(val.pos.x) + ";" + str(val.pos.y) + ";" + str(val.size.x) + ";" + str(val.size.y)
		ini.set_value( section, key, v )
	
	elif typeof(val) == TYPE_COLOR:
	
		var v = "@color " + val.to_html( )
		ini.set_value( section, key, v )
	
	else:
	
		ini.set_value( section, key, val )




# internal
func _recursive_read( ini, section ):
	
	if not ini.has_section( section ):
		
		printerr( "Section not found '" + section + "'." )
		return null
	
	
	if ini.has_section_key( section, "@is_array" ) and ini.get_value( section, "@is_array" ):
		
		var arr = []
		var length = ini.get_value( section, "length" )
		
		
		if length == null:
			
			printerr ("Invalid array '" + section + "'.")
			return null
		
		
		for i in range(length):
			
			var key = "item-" + str(i+1)
			
			if ini.has_section_key( section, key ):
				
				var val = ini.get_value( section, key )
				
				if str(val) == "@nested":
					
					arr.push_back( _recursive_read( ini, section + "." + str(i+1) ) )
				
				else:
					
					arr.push_back( val )
		
		return arr
	
	
	else:
		
		var dict = {}
		var keys = ini.get_section_keys( section )
		
		for key in keys:
			
			var val = ini.get_value( section, key )
			
			if str(val) == "@nested":
				
				dict[key] = _recursive_read( ini, section + "." + key )
				
			else:
				
				dict[key] = val
		
		return dict
