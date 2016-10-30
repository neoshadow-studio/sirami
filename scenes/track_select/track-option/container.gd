
extends Control

export(Color) var background_color


func _ready():
	pass


func _draw( ):
	
	draw_rect( get_rect( ), background_color )


