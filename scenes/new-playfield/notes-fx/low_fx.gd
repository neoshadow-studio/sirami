
extends Node2D


const FXNormal = preload( "res://scenes/playfield/low_fx/fx_normal.tscn" )
const FXClap = preload( "res://scenes/playfield/low_fx/fx_clap.tscn" )
const FXWhistle = preload( "res://scenes/playfield/low_fx/fx_whistle.tscn" )
const FXFinish = preload( "res://scenes/playfield/low_fx/fx_finish.tscn" )


var playfield


func _ready():
	pass



func initialize( pf ):
	
	playfield = pf



func spawn_normal( y ):
	
	var ins = FXNormal.instance( )
	add_child( ins )
	
	var scale = 0.1 * playfield.get_size( ).y * playfield.notes.size / ins.get_texture( ).get_size( ).y
	scale *= 2
	ins.set_scale( Vector2( scale, scale ) )
	
	var x = playfield.timeline_visual_offset + (ins.get_texture( ).get_size( ).y * scale / 2)
	ins.set_pos( Vector2( x, y ) )


func spawn_clap( y ):
	
	var ins = FXClap.instance( )
	add_child( ins )
	
	var scale = 0.1 * playfield.get_size( ).y * playfield.notes.size / ins.get_texture( ).get_size( ).y
	scale *= 2
	ins.set_scale( Vector2( scale, scale ) )
	
	var x = playfield.timeline_visual_offset + (ins.get_texture( ).get_size( ).y * scale / 2)
	ins.set_pos( Vector2( x, y ) )



func spawn_finish( y ):
	
	var ins = FXFinish.instance( )
	add_child( ins )
	
	var scale = 0.15 * playfield.get_size( ).y * playfield.notes.size / ins.get_texture( ).get_size( ).y
	scale *= 2
	ins.set_scale( Vector2( scale, scale ) )
	
	var x = playfield.timeline_visual_offset
	ins.set_pos( Vector2( x, y ) )



func spawn_whistle( y ):
	
	var ins = FXWhistle.instance( )
	add_child( ins )
	
	var scale = 0.15 * playfield.get_size( ).y * playfield.notes.size / ins.get_texture( ).get_size( ).y
	scale *= 2
	ins.set_scale( Vector2( scale, scale ) )
	
	var x = playfield.timeline_visual_offset
	ins.set_pos( Vector2( x, y ) )