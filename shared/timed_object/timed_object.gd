### @class TimedObject
###
### @brief An object with a time and a duration.
###


extends Reference


const SpeedModifier = preload( "speed_modifier.gd" )


### @brief Create a new instance from raw data.
###
### @param data : The raw data.
###
### @return The created instance.
###
static func from_data( data ):
	
	if data.type == "speed-modifier":
		
		return SpeedModifier.from_data( data )




### @brief The starting time.
###
var start_time

### @brief The duration.
###
var duration

### @brief The timed object will modify the speed ?
###
var modify_speed = false



### @brief Emitted when the object starts.
###
signal started( )

### @brief Emitted when the object finishes.
###
signal finished( )




### @brief Create a new instance.
###
### @param time : The starting time.
### @param dura : The duration (optional, 0 by default).
###
func _init( time, dura = 0 ).( ):
	
	start_time = time
	duration = dura




### @brief Get the type of the timing object.
###
### @note Must be overloaded.
###
### @return The type of the timing object.
###
func type( ):
	
	printerr( "TimedObject.type : Unimplemented method." )
	return null




### @brief Called when the object is started.
###
### @param manager : The manager of the current instance.
###
func _started( manager ):
	
	pass


### @brief Called when the object is active.
###
### @param dt : The delta-time.
### @param manager : The manager of the current instance.
###
func _process( manager ):
	
	pass


### @brief Called when the object is finished.
###
### @param manager : The manager of the current instance.
###
func _finished( manager ):
	
	pass




### @brief Convert the actual instance into raw data.
###
### @return Raw data.
###
func to_data( ):
	
	return {
		"type": type( ),
		
		"start-time": start_time,
		"duration": duration
	}