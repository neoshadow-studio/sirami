
extends Node2D



export( Color ) var color = Color8( 255,255,255 )


func _ready():
	
	pass



func _draw( ):
	
	draw_rect( get_parent( ).get_rect( ), color )

