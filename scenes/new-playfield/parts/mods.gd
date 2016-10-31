### @class Part_Mods
###
### @brief Manage the mods.
###



extends Reference



const Auto = preload( "../mods/auto.gd" )




### @brief The playfield.
var playfield

### @brief Auto-mode.
var auto_mode = true

### @brief The auto mod.
var auto_mod = null




### @brief Initialize a new instance.
###
### @param pf : The playfield.
###
func _init( pf ):
	
	playfield = pf
	
	# If the auto mode is started
	if auto_mode:
		# We load the auto mod.
		auto_mod = Auto.new( pf )




### @brief Updates the mods.
###
### @param dt : The delta-time.
###
func process( dt ):
	
	# If the auto-mode is enabled
	if auto_mode:
		# We update it.
		auto_mod.process( dt )