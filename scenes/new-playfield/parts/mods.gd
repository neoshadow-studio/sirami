### @class Part_Mods
###
### @brief Manage the mods.
###



extends Reference



### @brief The playfield.
var playfield

### @brief Auto-mode.
var auto_mode = false




### @brief Initialize a new instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf
