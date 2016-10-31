
extends Node2D


const BasicNote = preload( "res://scenes/playfield/notes/basic_note.tscn" )


var playfield 

var speed = 0.7 # playfield width per seconds
var size = 1 # 0.1 playfield height


var notes = []
var index = 0


signal played( note )


func _ready():
	
	pass



func initialize( pf ):
	
	playfield = pf
	playfield.connect( "resized", self, "on_playfield_resized" )
	
	speed = playfield.track.difficulty.speed
	size = playfield.track.difficulty.size
	
	notes = playfield.track.notes
	
	for n in notes:
		
		n.time += playfield.time_offset
	
	set_fixed_process( true )
	set_process_input( true )



func _fixed_process( dt ):
	
	if index < notes.size( ):
	
		var speed = playfield.timed_object_manager.get_speed_at( playfield.get_time( ) ) * self.speed
		
		while true:
			
			if notes[ index ].time - ( 1 / speed ) < playfield.get_time( ):
				
				var ins = BasicNote.instance( )
				
				ins.time = notes[ index ].time
				ins.y_pos = notes[ index ].y_pos
				ins.samples = notes[ index ].samples
				ins.local_volume = notes[ index ].local_volume
				ins.volume = notes[ index ].volume
				
				ins.playfield = playfield
				ins.manager = self
				
				add_child( ins )
				index += 1
			
			else:
				
				break
			
			if index >= notes.size( ):
				
				break
	
	
	if can_skip( ):
		
		playfield.get_node( "high-gui/skip-bg" ).show( )
	
	else:
		
		playfield.get_node( "high-gui/skip-bg" ).hide( )




func get_speed( ):
	
	return speed * playfield.get_size( ).x




func _input( ev ):
	
	var auto = playfield.cursor.auto_mode
	
	if ( ev.is_action_pressed( "button_1" ) or ev.is_action_pressed( "button_2" ) ) and not auto:
		
		var note = get_first( )
		
		if not note:
			
			return
		
		if note.time - playfield.get_time( ) < 0.05 and note.is_cursor_in( playfield.cursor.get_pos( ).y ):
			
			note.play( )
	
	
	if ev.is_action_pressed( "skip" ) and can_skip( ):
		
		skip( )



func skip( ):
	
	if index == 0:
		
		playfield.music.play( notes[ 0 ].time - 3 )
	
	else:
		
		playfield.show_score_menu( )



func get_first( ):
	
	if get_child_count( ) == 0:
		
		return null
	
	
	var note = get_child( 0 )
	var i = 0
	
	while true:
		
		if i >= get_child_count( ):
			
			return null
		
		
		if not note:
			
			return null
		
		if not note.played:
			
			return note
		
		
		if i + 1 >= get_child_count( ):
			
			return null
		
		note = get_child( i + 1 )
		i += 1


func on_playfield_resized( ):
	
	for n in get_children( ):
		
		n.on_playfield_resized( )




func can_skip( ):
	
	var time = playfield.get_time( )
	
	if notes.size( ) == 0:
		
		return false
	
	
	if notes[ 0 ].time > time + 4:
		
		return true
	
	if notes[ notes.size( ) - 1 ].time + 1 < time:
		
		return true


