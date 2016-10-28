
extends Reference


var playfield

var list
var speed_modifiers

var sm_index = 0


func _init( pf ):
	
	playfield = pf
	
	self.list = playfield.track.timed_objects
	speed_modifiers = [ ]
	
	for to in list:
		
		to.start_time += playfield.time_offset
		
		if to.modify_speed:
			
			speed_modifiers.push_back( to )



func get_speed_at( time ):
	
	if speed_modifiers.size( ) == 0:
			
			return 1
	
	
	if time < speed_modifiers[ sm_index ].start_time:
		
		if time < speed_modifiers[ 0 ].start_time:
			
			return 1
		
		
		for i in range( speed_modifiers.size( ) - 1 ):
			
			if speed_modifiers[ i ].start_time < time and speed_modifiers[ i+1 ].start_time > time:
				
				var dt = time - speed_modifiers[ i ].start_time
				
				return speed_modifiers[ i ].get_speed( dt )
	
	else:
		
		for i in range( sm_index, speed_modifiers.size( ) - 1 ):
			
			if speed_modifiers[ i ].start_time < time and speed_modifiers[ i+1 ].start_time > time:
				
				var dt = time - speed_modifiers[ i ].start_time
				sm_index = i
				
				return speed_modifiers[ i ].get_speed( dt )
	
	
	var last = speed_modifiers[ speed_modifiers.size( ) - 1 ]
	return last.get_speed( time - last.start_time )


func get_final_speed_at( time ):
	
	return playfield.notes.speed * get_speed_at( time ) * playfield.get_size( ).x