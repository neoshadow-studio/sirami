
extends Sprite

const SAMPLE_NONE = 0x00

const SAMPLE_NORMAL = 0x01
const SAMPLE_CLAP = 0x02
const SAMPLE_FINISH = 0x04
const SAMPLE_WHISTLE = 0x08

const SAMPLE_ALL = SAMPLE_NORMAL | SAMPLE_CLAP | SAMPLE_FINISH | SAMPLE_WHISTLE



var type = "basic"

var time
var y_pos

var samples = SAMPLE_NONE

var local_volume = false
var volume = 1


var playfield
var manager

var speed

var played = false



func _ready():
	
	on_playfield_resized( )
	
	set_fixed_process( true )



func on_playfield_resized( ):
	
	speed = playfield.timed_object_manager.get_final_speed_at( time )
	
	var scale = (playfield.get_size( ).y * 0.1 * manager.size) / get_texture( ).get_size( ).y
	set_scale( Vector2( scale, scale ) )
	
	var y = playfield.get_size( ).y - ( get_texture( ).get_size( ).y * scale )
	y = y * y_pos + (get_texture( ).get_size( ).y * scale / 2)
	
	var x = playfield.timeline_visual_offset + (time - playfield.get_time( )) * speed
	
	set_pos( Vector2( x, y ) )



func _fixed_process( dt ):
	
	if played:
		return
	
	
	var x = playfield.timeline_visual_offset + (time - playfield.get_time( )) * speed
	
	var p = get_pos( )
	p.x = x
	
	set_pos( p )
	
	
	if time < playfield.get_time( ) and playfield.cursor.auto_mode:
		
		play( true )
	
	if time < playfield.get_time( ) and not playfield.score_manager.can_be_played( self ):
		play( )




func play( auto = false ):
	
	if played:
		return
	
	played = true
	
	var score = playfield.score_manager.get_score( self )
	
	
	if auto:
		
		score = 100
	
	
	playfield.score_manager.add_score( score )
	
	
	if score == 100:
		
		playfield.high_fx.spawn_100( get_pos( ).y )
	
	if score == 50:
		
		playfield.high_fx.spawn_50( get_pos( ).y )
	
	if score == 10:
		
		playfield.high_fx.spawn_10( get_pos( ).y )
	
	if score == 0:
		
		playfield.high_fx.spawn_miss( get_pos( ).y )
	
	
	if score != 0:
	
		if ( samples & SAMPLE_FINISH ) != 0:
			
			playfield.low_fx.spawn_finish( get_pos( ).y )
		
		elif ( samples & SAMPLE_WHISTLE ) != 0:
			
			playfield.low_fx.spawn_whistle( get_pos( ).y )
		
		elif  ( samples & SAMPLE_CLAP ) != 0:
			
			playfield.low_fx.spawn_clap( get_pos( ).y )
			
		elif ( samples & SAMPLE_NORMAL ) != 0:
			
			playfield.low_fx.spawn_normal( get_pos( ).y )
	
		playfield.play_samples( samples )
		
		manager.emit_signal( "played", self )
	
	
	get_node( "anim" ).play( "fade" )




func is_cursor_in( cursor_y ):
	
	var top = get_pos( ).y - ( get_texture( ).get_size( ).y * get_scale( ).y / 2 )
	var bottom = get_pos( ).y + ( get_texture( ).get_size( ).y * get_scale( ).y / 2 )
	
	if cursor_y > top and cursor_y < bottom:
		
		return true
	
	return false




func _on_anim_finished():
	queue_free( )
	manager.remove_child( self )





static func from_data( d ):
	
	var time
	var y_pos
	var samples
	var local_volume
	var volume
	
	var data = d.split( ";" )
	time = float( data[ 1 ] )
	y_pos = float( data[ 2 ] )
	samples = int( data[ 3 ] )
	local_volume = data[ 4 ] == "true"
	volume = float( data[ 5 ] )
	
	
	
	var ins = new( )
	
	ins.time = time
	ins.y_pos = y_pos
	ins.samples = samples
	ins.local_volume = local_volume
	ins.volume = volume
	
	return ins


func to_data( ):
	
	var s = ""
	
	s += "basic;%d;%d;%d;%s;%d" % [
		time, y_pos, samples,
		(local_volume and "true" or "false"),
		volume
	]
	
	return s