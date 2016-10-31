### @class TrackSelect
###
### @brief The track selection scene.
###


extends Container




const MainMenu = preload( "res://scenes/main-menu/main-menu.tscn" )
const IniStream = preload( "res://data/ini_stream.gd" )
const Track = preload( "res://shared/track/track.gd" )
const TrackItem = preload( "res://scenes/track_select/track-item/track-item.tscn" )
const TrackOption = preload( "res://scenes/track_select/track-option/track-option.tscn" )
const Playfield = preload( "res://scenes/playfield/playfield.tscn" )




### @brief Track database.
onready var database = get_node( "/root/database" ) 

### @brief Track grid.
onready var grid = get_node( "scroll/center/grid" )

### @brief The thumbnail loading list.
var loading_list = []
### @brief The thumbnail loading thread.
var loading_thread

### @brief The scene is exited ?
var exited = false




### @brief Called whene the node is ready in the scene.
###
func _ready():
	
	# Connect the resized signal
	connect( "resized", self, "_on_resized" )
	
	# If not database updated
	if not database.updated:
		# We wait until it's updated.
		database.connect( "database_updated", self, "_on_database_updated" )
	
	# Otherwise
	else:
		# We directly shows the tracks from the database.
		_on_database_updated( )




### @brief Finish the loading thread.
###
func finish_thread( ):
	
	# If the loading thread exists
	if loading_thread != null:
		# We wait for it to finish.
		loading_thread.wait_to_finish( )




### @brief Open the given track information.
###
### @param track : The track information.
###
func open_track_info( track ):
	
	# We create a new instanec and setup it
	var ins = TrackOption.instance( )
	ins.db_entry = track
	
	# We add it.
	get_tree( ).get_root( ).add_child( ins )




### @brief Load the thumbnails.
###
### This is a thread.
###
func _load_thumbnails( a ):
	
	# We iterate over the loading list.
	for i in range( loading_list.size( ) ):
		
		# We get the grid's node
		var n = grid.get_child( i )
		
		# We load the texture
		var tex = load( loading_list[ i ] )
		
		# And notify the grid item that the texture is loaded.
		n.on_thumbnail_loaded( tex )




### @brief Signal: `database.database_updated`
###
func _on_database_updated( ):
	
	# If the database is empty.
	if database.database.size( ) == 0:
		
		# We create a new instance
		var ins = TrackItem.instance( )
		
		# We don't setup it so its show a "No track".
		grid.add_child( ins )
		return
	
	
	# We iterate over the tracks
	for track in database.database:
		
		# We create a new instance
		var ins = TrackItem.instance( )
		
		# We get the thumbnail path and add it to the loading list.
		var path = track.path.get_base_dir( ) + "/" + track.thumbnail
		loading_list.push_back( path )
		
		# We setup the instance
		ins.track_path = track.path
		ins.db_entry = track
		
		# And we add it to the grid.
		grid.add_child( ins )
	
	
	# We start the thumbnail loading thread.
	loading_thread = Thread.new( )
	loading_thread.start( self, "_load_thumbnails" )




### @brief Signal: `self.resized`
###
func _on_resized( ):
	
	# >e get the actual number of columns
	var n = grid.get_columns( )
	# We compute the size of the grid.
	var width = 244 * n - 4
	
	
	# If the width is too high
	if width + 20 > get_size( ).x and n > 1:
		
		# We search the correct number of columns.
		while width + 20 > get_size( ).x:
			
			n -= 1
			width = 244 * n - 4
		
		# And set it.
		grid.set_columns( n )
	
	# If the width is too low
	elif 244 * n - 4 < get_size( ).x:
		
		# We search the correct number of columns.
		while width + 20 < get_size( ).x:
			
			n += 1
			width = 244 * n - 4
		
		# And set it
		grid.set_columns( n - 1 )




### @brief Signal: `back.pressed`
###
func _on_back_pressed():
	
	# If we already exited
	if exited:
		# We do nothing
		return
	
	# We define the scene as exited
	exited = true
	
	# We create a new instance of the main menu.
	var ins = MainMenu.instance( )
	
	# We finish the loading thread and switch scene.
	finish_thread( )
	scene_switcher.switch_with_fade( self, ins )
