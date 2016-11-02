### @class Settings
###
### @brief Manage, save and load the player settings.
###



extends Node



### @brief The IniStream.
const IniStream = preload( "res://data/ini_stream.gd" )




### @brief The settings.
var settings = {
	"playfield": {
		"hide_background": false,
		"hide_sirami": false,
		"visual_offset": 0,
		"time_offset": 0
	},
	
	"audio": {
		"global_volume": 1,
		"samples_volume": 1,
		"music_volume": 1
	},
	
	"keys": {
		"left": KEY_W,
		"right": KEY_X
	}
}




### @brief Signal emitted when a setting is changed.
###
signal changed( section, name, new_value, old_value )




### @brief Called when the node is ready in the tree.
###
func _ready( ):
	
	# We create the new ini stream
	var ini = IniStream.new( "user://settings.ini" )
	ini.namespace = "settings"
	
	# We load the data from the settings.
	var data = ini.read( )
	
	# If there are data
	if data != null:
		
		# We save it.
		settings = data
	
	# We reload the keys.
	reload_keys( )




### @brief Reloads the keys.
###
func reload_keys( ):
	
	# We remove the actions
	InputMap.erase_action( "key_1" )
	InputMap.erase_action( "key_2" )
	
	# We re-add them
	InputMap.add_action( "key_1" )
	InputMap.add_action( "key_2" )
	
	# We create the input event for the first key
	var k1 = InputEvent( )
	k1.type = InputEvent.KEY
	k1.scancode = settings.keys.left
	
	# We create the input event for the second key
	var k2 = InputEvent( )
	k2.type = InputEvent.KEY
	k2.scancode = settings.keys.right
	
	# We add the events to the actions.
	InputMap.action_add_event( "key_1", k1 )
	InputMap.action_add_event( "key_2", k2 )




### @brief Called when the node exits the tree.
###
func _exit_tree( ):
	
	# We create a new ini stream
	var ini = IniStream.new( "user://settings.ini" )
	ini.namespace = "settings"
	
	# And save the settings.
	ini.write( settings )




### @brief Get a setting.
###
### @param section : The setting's section.
### @param name : The setting's name.
### @param def : The default value.
###
func get_setting( section, name, def=null ):
	
	# If the section doesn't exists
	if not settings.has( section ):
		
		# If we have a default value
		if def != null:
			# We save it.
			set_setting( section, name, def )
		
		# We return the default value.
		return def
	
	
	# If the key does not exist in the section
	if not settings[ section ].has( name ):
		
		# If we have a default value
		if def != null:
			# We save it.
			set_setting( section, name, def )
		
		# We return the default value
		return def
	
	
	# We return the value.
	return settings[ section ][ name ]


### @brief Set a setting.
###
### @param section : The setting's section.
### @param name : The setting's name.
### @param value : The setting's value.
###
func set_setting( section, name, value ):
	
	if not settings.has( section ):
		
		settings[ section ] = { }
	
	var old_value = get_setting( section, name )
	settings[ section ][ name ] = value
	
	emit_signal( "changed", section, name, value, old_value )