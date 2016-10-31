### @brief Sirami
###
### @brief Update the Sirami label.
###



extends Sprite




### @brief The factor of the rect.
export(float, 0, 1, 0.05) var factor = 0 setget set_factor, get_factor





### @brief Set the rect factor.
###
### @param v : The new factor.
###
func set_factor( v ):
	
	# We keep the factor
	factor = v
	
	# We update the width and the height of the rect
	var tex = get_texture()
	var width = tex.get_width() * factor
	var height = tex.get_height()
	
	# We set the rect
	var rect = Rect2(0, 0, width, height)
	set_region_rect(rect)
	
	# If the factor is more than or equals to 1
	if v >= 1:
		# We remove the script.
		set_script( null )


### @rief Get the rect factor.
###
### @return The rect factor.
###
func get_factor( ):
	
	return factor