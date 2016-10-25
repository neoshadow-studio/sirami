### @class TimedObjectManager
###
### @brief Manage a set of timed object.
###


extends Reference



### @brief The clocks manager.
###
var clocks

### @brief The clock used by the manager.
###
var clock




### @brief The set of timed object.
###
var timed_objects

### @brief The set of alive timed object.
###
var alives

### @brief The current index in the `timed_objects` list.
###
var index




### @brief Initialize a new instance.
###
### @param clocks : The clock manager.
### @param timed_objects : The timed object list.
### @param clock : The clock to use.
###
func _init( clocks, timed_objects = [], clock = "default" ).( ):
	
	self.clocks = clocks
	self.clock = clock
	
	self.timed_objects = timed_objects
	self.alive = []
	self.index = 0
	
	self.timed_objects.sort_custom( self, "_sort" )




## Internal
func _sort( a, b ):
	
	return a.start_time < b.start_time




### @brief Updates the manager.
###
func process( ):
	
	var time = clocks.get_time( clock )
	
	
	while index < timed_objects.size( ):
		
		var to = timed_objects[ index ]
		
		if to.start_time <= time:
			
			alives.push_back( to )
			index += 1
			
			to._started( self )
			to.emit_signal( "started" )
		
		else:
			
			break
	
	
	var to_remove = [ ]
	
	for idx in range( alives.size( ) ):
		
		var alive = alives[ idx ]
		
		if alive.start_time + alive.duration <= time:
			
			to_remove.push_back( idx )
			
			alive._finished( self )
			alive.emit_signal( "finished" )
		
		else:
		
			alive._process( self )
	
	
	to_remove.sort( )
	
	for i in range( to_remove.size( ) ):
		
		alives.erase( to_remove[ i ] - i )
		