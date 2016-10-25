### @class Clocks
###
### @brief A manager which handles a set of clock.
###


extends Node


### @brief The set of clocks.
###
var clocks




### @brief Called when the node is ready in the scene.
###
func _ready( ):
	
	clocks = { }
	
	add_clock( "default" )
	
	set_process( true )




### @brief Update the node.
###
### @param dt : The delta-time.
###
func _process( dt ):
	
	for key in clocks.keys( ):
		
		if clocks[ key ].automatic:
			
			clocks[ key ].last_time = clocks[ key ].time
			clocks[ key ].time += dt * clocks[ key ].speed




### @brief Add a clock.
###
### @param name : The clock's name.
###
### @return `Error`.
###
func add_clock( name ):
	
	if clocks.has( name ):
		
		printerr( "Clock already exists : '" + name + "'." )
		return ERR_INVALID_PARAMETER
	
	
	clocks[ name ] = {
		"last_time": 0,
		"time": 0,
		"speed": 1,
		"automatic": true
	}
	
	return OK


### @brief Remove a clock.
###
### @param name : The clock's name.
###
### @return `Error`
###
func remove_clock( name ):
	
	if not clocks.has( name ):

		printerr( "Clock doesn't exist : '" + name + "'." )
		return ERR_INVALID_PARAMETER
	
	
	clocks.erase( name )
	return OK




### @brief Get the actual time of a clock.
###
### @param name : The clock's name.
###
### @return The actual time of the clock, or null.
###
func get_time( name ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return null
	
	
	return clocks[ name ].time


### @brief Get the actual delta-time of a clock.
###
### @param name : The clock's name.
###
### @return The actual delta-time of the clock, or null.
###
func get_delta_time( name ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return null
	
	
	return clocks[ name ].time - clocks[ name ].last_time


### @brief Get the actual speed of a clock.
###
### @param name : The clock's name.
###
### @return The actual speed of the clock, or null.
###
func get_speed( name ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return null
	
	
	return clocks[ name ].speed


### @brief Is the clock automatically updated ?
###
### @param name : The clock's name.
###
### @return True if the clock is automatically updated, or false.
### 		null if the clock does not exits.
###
func is_automatic( name ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return null
	
	
	return clocks[ name ].automatic




### @brief Set the actual time of the clock.
###
### @param name : The clock's name.
### @param value : The new time of the clock.
###
### @return `Error`
###
func set_time( name, value ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return ERR_INVALID_PARAMETER
	
	
	clocks[ name ].last_time = clocks[ name ].time
	clocks[ name ].time = value
	return OK


### @brief Set the actual speed of the clock.
###
### @param name : The clock's name.
### @param value : The new speed of the clock.
###
### @return `Error`
###
func set_speed( name, value ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return ERR_INVALID_PARAMETER
	
	
	clocks[ name ].speed = value
	return OK


### @brief Set the clock in automatic mode.
###
### @param name : The clock's name.
###
### @return `Error`
###
func enable( name ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return ERR_INVALID_PARAMETER
	
	
	clocks[ name ].automatic = true
	return OK


### @brief Set the clock in manual mode.
###
### @param name : The clock's name.
###
### @return `Error`
###
func disable( name ):
	
	if not clocks.has( name ):
		
		printerr( "Clock doesn't exist : '" + name + "'." )
		return ERR_INVALID_PARAMETER
	
	
	clocks[ name ].automatic = false
	return OK

