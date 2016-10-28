

extends Reference



static func from_data( data ):
	
	var ins = new( )
	
	ins.start_time = data.start_time
	ins.speed = data.speed
	
	return ins


var start_time = 0

var modify_speed = true

var speed = 0


func get_speed( dt ):
	
	return speed


func type( ):
	
	return "speed-modifier"


func to_data( ):
	
	return {
		"type": type(),
		"start_time": start_time,
		"speed": speed
	}
