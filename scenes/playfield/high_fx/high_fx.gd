
extends Node2D


const Score100 = preload( "res://scenes/playfield/scores/score_100.tscn" )
const Score50 = preload( "res://scenes/playfield/scores/score_50.tscn" )
const Score10 = preload( "res://scenes/playfield/scores/score_10.tscn" )
const ScoreMiss = preload( "res://scenes/playfield/scores/score_miss.tscn" )


var playfield

var scale


func _ready():
	
	pass



func initialize( pf ):
	
	playfield = pf
	
	var ins = ScoreMiss.instance( )
	scale = ( playfield.timeline_visual_offset * 0.4 ) / ins.get_region_rect( ).size.x
	
	ins.free( )



func _setup( ins, y ):
	
	var pos = Vector2( 0, 0 )
	
	ins.set_scale( Vector2( scale, scale ) )
	
	pos.y = y
	pos.x = playfield.timeline_visual_offset - ( ins.get_region_rect( ).size.x * scale / 2 ) - 64
	
	ins.set_pos( pos )



func spawn_100( y ):
	
	var ins = Score100.instance( )
	add_child( ins )
	
	_setup( ins, y )


func spawn_50( y ):
	
	var ins = Score50.instance( )
	add_child( ins )
	
	_setup( ins, y )


func spawn_10( y ):
	
	var ins = Score10.instance( )
	add_child( ins )
	
	_setup( ins, y )


func spawn_miss( y ):
	
	var ins = ScoreMiss.instance( )
	add_child( ins )
	
	_setup( ins, y )
	ins.set_rotd( 10 )

