### @class Part_Score
###
### @brief Manage the score.
###



extends Reference




### @brief Score 100
const SCORE_100 = 100
### @brief Score 50
const SCORE_50 = 50
### @brief Score 10
const SCORE_10 = 10
### @brief Score miss
const SCORE_MISS = 0

### @brief Delta-time for score 100
const DT_100 = 0.02
### @brief Delta-time for score 50
const DT_50 = 0.03
### @brief Delta-time for score 10
const DT_10 = 0.06
### @brief Delta-time for miss
const DT_MISS = 0.08

### @brief Accuracy value for score 100
const ACC_100 = 1
### @brief Accuracy value for score 50
const ACC_50 = 0.67
### @brief Accuracy value for score 10
const ACC_10 = 0.33
### @brief Accuracy value for miss
const ACC_MISS = 0




### @brief Timing factor.
var factor = 1

### @brief Current score.
var score = 0 
### @brief Current combo.
var combo = 0
### @brief Current accuracy.
var accuracy = 1

### @brief Number of note played in total
### (includ missed notes)
var note_played = 0

### @brief Number of 100 played.
var note_100_played = 0
### @brief Number of 50 played
var note_50_played = 0
### @brief Number of 10 played
var note_10_played = 0
### @brief Number of missed notes.
var note_missed = 0

### @brief Max combo in the session.
var max_combo = 0

### @brief The playfield.
var playfield




### @brief Signal emitted when the score change.
signal score_changed( )
### @brief Signal emitted when the combo is lost.
signal combo_lost( )




### @brief Initialize a new instance.
###
func _init( pf ):
	
	playfield = pf




### @brief Check if the note can be played.
###
### @param note : The note.
### @return True if the note can be played.
###
func can_be_played( note ):
	
	# We compute the delta-time
	var dt = abs( playfield.time.get_time( ) - note.time )
	
	# If the DT is less than the DT for miss.
	if dt <= DT_MISS * factor:
		# We return true.
		return true
	
	# We return false otherwise.
	return false




### @brief Get the score of the note.
###
### @param note : The note.
### @return The obtained score.
###
func get_score( note ):
	
	# We compute the delta-time
	var dt = abs( playfield.time.get_time( ) - note.time )
	
	# If this is a 100
	if dt <= DT_100 * factor:
		return SCORE_100
	
	# If this is a 50
	if dt <= DT_50 * factor:
		return SCORE_50
	
	# If this is a 10
	if dt <= DT_10 * factor:
		return SCORE_10
	
	# Otherwise this is a miss.
	return SCORE_MISS




### @brief Add a score.
###
### @param score : The score too add.
### @param inc_notes : Increase the note count.
###
func add_score( score, inc_notes = true ):
	
	# We increase the score
	self.score += score * ( 1 + combo * 0.1 )
	
	# If we increase the note count
	if inc_notes:
		note_played += 1
	
	
	# If this is a 100
	if score == SCORE_100:
		
		# We compute the new accuracy
		accuracy = ( note_played - 1 ) * accuracy + ACC_100
		accuracy /= note_played
		
		# We increase the combo
		combo += 1
		
		# We emit the score_changed signal
		emit_signal( "score_changed" )
		
		# We increase the number of 100 obtained.
		if inc_notes:
			note_100_played += 1
	
	
	# If this is a 50
	if score == SCORE_50:
		
		# We compute the new accuracy
		accuracy = ( note_played - 1 ) * accuracy + ACC_50
		accuracy /= note_played
		
		# We increase the combo
		combo += 1
		
		# We emit the score_changed signal
		emit_signal( "score_changed" )
		
		# We increase the number of 50 obtained
		if inc_notes:
			note_50_played += 1
	
	
	# If this is a 10
	if score == SCORE_10:
		
		# We compute the new accuracy
		accuracy = ( note_played - 1 ) * accuracy + ACC_10
		accuracy /= note_played
		
		# We increase the combo
		combo += 1
		
		# We emit the score_changed signal
		emit_signal( "score_changed" )
		
		# We increase the number of 10 obtained
		if inc_notes:
			note_10_played += 1
	
	
	# If this is a miss
	if score == SCORE_MISS:
		
		# We compute the new accuracy
		accuracy = ( note_played - 1 ) * accuracy + ACC_MISS
		accuracy /= note_played
		
		# We reset the combo
		combo = 0
		
		# We emit the combo lost signal
		emit_signal( "combo_lost" )
		
		if inc_notes:
			note_missed += 1
	
	
	# We keep the highest combo
	max_combo = max( combo, max_combo )

